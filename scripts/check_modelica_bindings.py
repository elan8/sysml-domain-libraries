#!/usr/bin/env python3
"""Check every `@ModelicaModel` binding under `model/` against its Modelica class.

For each part definition with a binding (Elan8::PhysicalModeling::ModelicaModel):

- the class resolves: without `resourceUri`, `Elan8.A.B.C` is `modelica/Elan8/A/B/C.mo`;
  with it, the file is relative to the SysML file and declares the class;
- every parameter of the class names an attribute of the part definition or a supertype;
- every pin of the class names a port of the part definition or a supertype.

This is a lint on source text, not a SysML or Modelica parser: it reads part definitions,
their `:>` supertypes by simple name, and `parameter` and `Pin` declarations before
`protected`. Spec42 validates the SysML; rumoca compiles and simulates the Modelica
(`modelica/tests/run.sh`).

Usage:
    python3 scripts/check_modelica_bindings.py
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODEL = ROOT / "model"
MODELICA = ROOT / "modelica"

PART_DEF = re.compile(r"\bpart\s+def\s+(\w+)\s*((?::>\s*[\w:]+(?:\s*,\s*[\w:]+)*)?)\s*([{;])")
BINDING = re.compile(r"@(?:[\w:]*::)?ModelicaModel\s*\{(.*?)\}", re.S)
FIELD = re.compile(r'(\w+)\s*=\s*"([^"]*)"\s*;')
ATTRIBUTE = re.compile(r"\battribute\s+(?::>>\s*)?(\w+)")
PORT = re.compile(r"\bport\s+(\w+)")
PARAMETER = re.compile(r"^\s*parameter\s+[\w.]+(?:\([^)]*\))?\s+(\w+)", re.M)
PIN = re.compile(r"^\s*Modelica\.Electrical\.Analog\.Interfaces\.(?:Pin|PositivePin|NegativePin)\s+(\w+)", re.M)


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
    out, depth, index = [], 0, 0
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
    """name -> list of (file, supertypes, attributes, ports, binding fields)."""
    found = {}
    for path in sorted(MODEL.rglob("*.sysml")):
        text = re.sub(r"/\*.*?\*/", "", path.read_text(encoding="utf-8"), flags=re.S)
        text = re.sub(r"//[^\n]*", "", text)
        for match in PART_DEF.finditer(text):
            name, supers, opener = match.groups()
            supertypes = [s.strip().split("::")[-1] for s in supers.lstrip(":> ").split(",") if s.strip()]
            content = body(text, match.end() - 1) if opener == "{" else ""
            own = without_nested_parts(content)
            binding = BINDING.search(own)
            found.setdefault(name, []).append(
                {
                    "file": path,
                    "supertypes": supertypes,
                    "attributes": set(ATTRIBUTE.findall(own)),
                    "ports": set(PORT.findall(own)),
                    "binding": dict(FIELD.findall(binding.group(1))) if binding else None,
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


def modelica_class(binding, sysml_file):
    """The public text of the bound class, or an error."""
    class_name = binding.get("className", "")
    simple = class_name.split(".")[-1]
    if "resourceUri" in binding:
        path = (sysml_file.parent / binding["resourceUri"]).resolve()
    else:
        path = MODELICA.joinpath(*class_name.split(".")).with_suffix(".mo")
    if not path.is_file():
        return None, f"class `{class_name}` not found at {path.relative_to(ROOT) if path.is_relative_to(ROOT) else path}"
    text = path.read_text(encoding="utf-8")
    start = re.search(rf"\b(?:model|block|class|package)\s+{re.escape(simple)}\b", text)
    if not start:
        return None, f"{path.relative_to(ROOT)} does not declare `{simple}`"
    end = re.search(rf"\bend\s+{re.escape(simple)}\s*;", text[start.end() :])
    declaration = text[start.end() : start.end() + end.start()] if end else text[start.end() :]
    return declaration.split("protected")[0], None


def main() -> int:
    defs = part_definitions()
    problems, checked = [], 0
    for name, definitions in sorted(defs.items()):
        for definition in definitions:
            binding = definition["binding"]
            if binding is None:
                continue
            checked += 1
            where = f"{definition['file'].relative_to(ROOT)}: part def {name}"
            if "className" not in binding:
                problems.append(f"{where}: @ModelicaModel without className")
                continue
            public, error = modelica_class(binding, definition["file"])
            if error:
                problems.append(f"{where}: {error}")
                continue
            attributes, ports = features(defs, name)
            for parameter in PARAMETER.findall(public):
                if parameter not in attributes:
                    problems.append(f"{where}: parameter `{parameter}` of {binding['className']} is no attribute of {name}")
            for pin in PIN.findall(public):
                if pin not in ports:
                    problems.append(f"{where}: pin `{pin}` of {binding['className']} is no port of {name}")
    for problem in problems:
        print(problem)
    print(f"{checked} binding(s) checked, {len(problems)} problem(s)")
    return 1 if problems or not checked else 0


if __name__ == "__main__":
    sys.exit(main())
