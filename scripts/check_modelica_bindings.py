#!/usr/bin/env python3
"""Check every `@ModelicaModel` binding under `model/` against its Modelica class.

For each part definition with a binding (Elan8::PhysicalModeling::ModelicaModel):

- the class resolves: in the Modelica Standard Library (`--msl`), in this repository's `Elan8`
  package (`modelica/Elan8`), or with `resourceUri` in a file next to the SysML file;
- every `parameters` and `pins` entry ("sysmlName=modelicaName") names an attribute or port of the
  part definition or a supertype, and a parameter or pin of the class;
- every parameter of the class without a default value, and every pin, is paired: by an entry or
  by a SysML attribute or port of the same name.

Class members include those inherited through `extends`, resolved as Modelica resolves names: in
the enclosing packages, innermost first.

This is a lint on source text, not a SysML or Modelica parser: it reads part definitions, their
`:>` supertypes by simple name, and the public `parameter` and pin declarations of the classes.
Spec42 validates the SysML; rumoca compiles and simulates the Modelica (`modelica/tests/run.sh`).

Usage:
    python3 scripts/check_modelica_bindings.py --msl "<MSL directory>/Modelica 4.1.0"
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODEL = ROOT / "model"
ELAN8 = ROOT / "modelica" / "Elan8"

PART_DEF = re.compile(r"\bpart\s+def\s+(\w+)\s*((?::>\s*[\w:]+(?:\s*,\s*[\w:]+)*)?)\s*([{;])")
BINDING = re.compile(r"@(?:[\w:]*::)?ModelicaModel\s*\{(.*?)\}", re.S)
STRING_FIELD = re.compile(r'(\w+)\s*=\s*"([^"]*)"\s*;')
LIST_FIELD = re.compile(r"(\w+)\s*=\s*\(([^)]*)\)\s*;")
ATTRIBUTE = re.compile(r"\battribute\s+(?::>>\s*)?(\w+)")
PORT = re.compile(r"\bport\s+(\w+)")

PARAMETER = re.compile(r"^\s*(?:final\s+)?parameter\s+([\w.]+)(\s*\([^;]*?\))?\s+(\w+)([^;]*);", re.M)
PIN_TYPES = ("Pin", "PositivePin", "NegativePin")
COMPONENT = re.compile(r"^\s*([\w.]+)\s+(\w+)\b[^;]*;", re.M)
EXTENDS = re.compile(r"^\s*extends\s+([\w.]+)", re.M)


def body(text: str, start: int) -> str:
    """The text between the brace at `start` and its match."""
    depth = 0
    for index in range(start, len(text)):
        if text[index] == "{":
            depth += 1
        elif text[index] == "}":
            depth -= 1
            if depth == 0:
                return text[start + 1 : index]
    return text[start + 1 :]


def without_nested_parts(text: str) -> str:
    """Drop nested part bodies so their features are not read as the definition's own."""
    out, index = [], 0
    nested = re.compile(r"\bpart\s+(?!def\b)\w+[^;{]*\{")
    while index < len(text):
        match = nested.search(text, index)
        if not match:
            out.append(text[index:])
            break
        out.append(text[index : match.start()])
        depth, cursor = 1, match.end()
        while cursor < len(text) and depth:
            depth += {"{": 1, "}": -1}.get(text[cursor], 0)
            cursor += 1
        index = cursor
    return "".join(out)


def part_definitions():
    """name -> list of definitions: file, supertypes, attributes, ports and binding."""
    found = {}
    for path in sorted(MODEL.rglob("*.sysml")):
        text = re.sub(r"/\*.*?\*/", "", path.read_text(encoding="utf-8"), flags=re.S)
        text = re.sub(r"//[^\n]*", "", text)
        for match in PART_DEF.finditer(text):
            name, supers, opener = match.groups()
            supertypes = [s.strip().split("::")[-1] for s in supers.lstrip(":> ").split(",") if s.strip()]
            own = without_nested_parts(body(text, match.end() - 1) if opener == "{" else "")
            binding = BINDING.search(own)
            fields = None
            if binding:
                fields = dict(STRING_FIELD.findall(binding.group(1)))
                for key, values in LIST_FIELD.findall(binding.group(1)):
                    fields[key] = re.findall(r'"([^"]*)"', values)
            found.setdefault(name, []).append(
                {
                    "file": path,
                    "supertypes": supertypes,
                    "attributes": set(ATTRIBUTE.findall(own)),
                    "ports": set(PORT.findall(own)),
                    "binding": fields,
                }
            )
    return found


def features(defs, name, seen=None):
    """Attributes and ports of `name` and all its supertypes found in this repository."""
    seen = seen if seen is not None else set()
    attributes, ports = set(), set()
    if name in seen:
        return attributes, ports
    seen.add(name)
    for definition in defs.get(name, []):
        attributes |= definition["attributes"]
        ports |= definition["ports"]
        for supertype in definition["supertypes"]:
            more_attributes, more_ports = features(defs, supertype, seen)
            attributes |= more_attributes
            ports |= more_ports
    return attributes, ports


class Modelica:
    """Class lookup in a set of Modelica library roots, by qualified name."""

    def __init__(self, roots: dict[str, Path]):
        self.roots = roots  # top-level package name -> its directory or file

    def source(self, qualified: str):
        """The text of class `qualified` and its enclosing package, or None."""
        parts = qualified.split(".")
        root = self.roots.get(parts[0])
        if root is None:
            return None
        directory = root
        for index, part in enumerate(parts[1:], start=1):
            if (directory / part).is_dir():
                directory = directory / part
                continue
            simple = parts[-1]
            for candidate in [directory / f"{part}.mo", directory / "package.mo"]:
                if candidate.is_file():
                    text = candidate.read_text(encoding="utf-8", errors="replace")
                    declaration = self._declaration(text, simple)
                    if declaration is not None:
                        return declaration, ".".join(parts[:-1])
            return None
        package = directory / "package.mo"
        if package.is_file():
            declaration = self._declaration(package.read_text(encoding="utf-8", errors="replace"), parts[-1])
            if declaration is not None:
                return declaration, ".".join(parts[:-1])
        return None

    @staticmethod
    def _declaration(text: str, simple: str):
        start = re.search(
            rf"^\s*(?:partial\s+|encapsulated\s+|replaceable\s+)*(?:model|block|class|connector|record|package)\s+{re.escape(simple)}\b",
            text,
            re.M,
        )
        if not start:
            return None
        end = re.search(rf"\bend\s+{re.escape(simple)}\s*;", text[start.end() :])
        declaration = text[start.end() : start.end() + end.start()] if end else text[start.end() :]
        declaration = re.sub(r"annotation\s*\(.*?\);", ";", declaration, flags=re.S)
        return declaration.split("\nprotected")[0]

    def resolve(self, name: str, context: str) -> str | None:
        """Modelica name lookup: `name` in `context` and its enclosing packages, innermost first."""
        scopes = context.split(".") if context else []
        for depth in range(len(scopes), -1, -1):
            candidate = ".".join(scopes[:depth] + [name])
            if self.source(candidate) is not None:
                return candidate
        return None

    def members(self, qualified: str, seen=None):
        """(parameters {name: has_default}, pins) of a class, with inherited members."""
        seen = seen if seen is not None else set()
        parameters, pins = {}, set()
        found = self.source(qualified)
        if found is None or qualified in seen:
            return parameters, pins
        seen.add(qualified)
        text, package = found
        for _type, _modifier, name, rest in PARAMETER.findall(text):
            parameters[name] = has_default(rest)
        pins |= declared_pins(text)
        for base in EXTENDS.findall(text):
            resolved = self.resolve(base, package) or self.resolve(base, qualified)
            if resolved:
                more_parameters, more_pins = self.members(resolved, seen)
                for name, defaulted in more_parameters.items():
                    parameters.setdefault(name, defaulted)
                pins |= more_pins
        return parameters, pins


def has_default(rest: str) -> bool:
    """Whether a declaration's text after its name binds a value: `= value`, after any
    modifier such as `(start = 1)`, which is not a binding."""
    rest = rest.split('"')[0]
    depth, outside = 0, []
    for char in rest:
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif depth == 0:
            outside.append(char)
    return "=" in "".join(outside)


def declared_pins(text: str) -> set[str]:
    """Pins declared in a class's text, leaving out conditional ones (`... if condition`),
    which are absent unless enabled."""
    pins = set()
    for match in COMPONENT.finditer(text):
        type_name, name = match.groups()
        if type_name.split(".")[-1] in PIN_TYPES and not re.search(r"\bif\b", match.group(0)):
            pins.add(name)
    return pins


def pairs(entries, kind, where, problems):
    mapping = {}
    for entry in entries or []:
        if entry.count("=") != 1:
            problems.append(f"{where}: {kind} entry `{entry}` is not sysmlName=modelicaName")
            continue
        sysml, modelica = (side.strip() for side in entry.split("="))
        mapping[sysml] = modelica
    return mapping


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--msl", type=Path, help="the Modelica Standard Library's `Modelica <version>` directory")
    args = parser.parse_args()
    roots = {"Elan8": ELAN8}
    if args.msl:
        roots["Modelica"] = args.msl
    library = Modelica(roots)

    defs = part_definitions()
    problems, checked = [], 0
    for name, definitions in sorted(defs.items()):
        for definition in definitions:
            binding = definition["binding"]
            if binding is None:
                continue
            checked += 1
            where = f"{definition['file'].relative_to(ROOT)}: part def {name}"
            class_name = binding.get("className")
            if not class_name:
                problems.append(f"{where}: @ModelicaModel without className")
                continue
            if "resourceUri" in binding:
                path = (definition["file"].parent / binding["resourceUri"]).resolve()
                if not path.is_file():
                    problems.append(f"{where}: resourceUri {binding['resourceUri']} does not exist")
                    continue
                top = class_name.split(".")[0]
                library = Modelica({**roots, top: path.parent / top if (path.parent / top).is_dir() else path.parent})
                if library.source(class_name) is None and Modelica._declaration(path.read_text(encoding="utf-8"), class_name.split(".")[-1]) is None:
                    problems.append(f"{where}: {binding['resourceUri']} does not declare `{class_name}`")
                    continue
                text = Modelica._declaration(path.read_text(encoding="utf-8"), class_name.split(".")[-1])
                parameters = {n: has_default(r) for _t, _m, n, r in PARAMETER.findall(text)}
                pins = declared_pins(text)
                library = Modelica(roots)
            else:
                if class_name.split(".")[0] not in roots:
                    problems.append(f"{where}: no library for `{class_name}` (pass --msl for Modelica classes)")
                    continue
                if library.source(class_name) is None:
                    problems.append(f"{where}: class `{class_name}` not found")
                    continue
                parameters, pins = library.members(class_name)

            attributes, ports = features(defs, name)
            parameter_map = pairs(binding.get("parameters"), "parameters", where, problems)
            pin_map = pairs(binding.get("pins"), "pins", where, problems)
            for sysml, modelica in parameter_map.items():
                if sysml not in attributes:
                    problems.append(f"{where}: parameters entry `{sysml}` is no attribute of {name}")
                if modelica not in parameters:
                    problems.append(f"{where}: parameters entry `{modelica}` is no parameter of {class_name}")
            for sysml, modelica in pin_map.items():
                if sysml not in ports:
                    problems.append(f"{where}: pins entry `{sysml}` is no port of {name}")
                if modelica not in pins:
                    problems.append(f"{where}: pins entry `{modelica}` is no pin of {class_name}")
            supplied = set(parameter_map.values()) | (attributes & set(parameters))
            for parameter, defaulted in sorted(parameters.items()):
                if not defaulted and parameter not in supplied:
                    problems.append(f"{where}: parameter `{parameter}` of {class_name} has no default and no attribute")
            connected = set(pin_map.values()) | (ports & pins)
            for pin in sorted(pins - connected):
                problems.append(f"{where}: pin `{pin}` of {class_name} is no port of {name}")
    for problem in problems:
        print(problem)
    print(f"{checked} binding(s) checked, {len(problems)} problem(s)")
    return 1 if problems or not checked else 0


if __name__ == "__main__":
    sys.exit(main())
