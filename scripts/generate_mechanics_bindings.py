#!/usr/bin/env python3
"""Generate reviewed SysML bindings from the pinned Rumoca flattened class interfaces."""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from threading import get_ident

from check_modelica_bindings import ROOT, msl_catalog, part_definitions

MANIFEST = ROOT / "modelica/mechanics-pilot.json"
BEGIN = "    // BEGIN GENERATED MECHANICS BINDINGS"
END = "    // END GENERATED MECHANICS BINDINGS"
QUANTITIES = {
    "1": "DimensionOneValue",
    "N": "ForceValue",
    "s": "DurationValue",
    "m": "LengthValue",
    "rad": "AngularMeasureValue",
    "rad/s": "AngularVelocityValue",
    "rad/s2": "AngularAccelerationValue",
    "m/s": "SpeedValue",
    "m/s2": "AccelerationValue",
    "N.m": "TorqueValue",
    "W": "PowerValue",
    "N/m": "TranslationalStiffnessValue",
    "N.s/m": "TranslationalDampingValue",
    "N.m/rad": "RotationalStiffnessValue",
    "N.m.s/rad": "RotationalDampingValue",
    "rad/m": "RotationPerLengthValue",
}
SIGNALS = {
    "m": ("LinearPositionSignalPort", "position"),
    "rad": ("AngularPositionSignalPort", "angle"),
    "rad/s": ("AngularVelocitySignalPort", "angularVelocity"),
    "rad/s2": ("AngularAccelerationSignalPort", "angularAcceleration"),
    "m/s": ("LinearVelocitySignalPort", "velocity"),
    "m/s2": ("LinearAccelerationSignalPort", "acceleration"),
    "N": ("ForceSignalPort", "force"),
    "N.m": ("TorqueSignalPort", "torque"),
    "W": ("MechanicalPowerSignalPort", "power"),
}
FLANGES = {
    frozenset({("phi", "rad"), ("tau", "N.m")}): "RotationalMechanicalPort",
    frozenset({("s", "m"), ("f", "N")}): "TranslationalMechanicalPort",
}


def inspect_class(rumoca, roots, directory, class_name):
    # The reference loads the MSL class; --model flattens the class itself.
    directory.mkdir()
    probe = directory / "Probe.mo"
    probe.write_text(f"within ;\nmodel Probe\n  {class_name} partUnderTest;\nend Probe;\n", encoding="utf-8")
    output = directory / "flat.json"
    # Separate worker caches avoid concurrent Rumoca package-index writes.
    cache = directory.parent / f"cache-{get_ident()}"
    command = [
        str(rumoca), "compile", str(probe), "--model", class_name,
        "--emit", "flat-json", "-o", str(output), "--cache-dir", str(cache),
    ]
    for root in roots:
        command.extend(["--source-root", str(root)])
    result = subprocess.run(command, capture_output=True, text=True, encoding="utf-8", timeout=120)
    if result.returncode:
        raise ValueError(result.stderr.strip() or result.stdout.strip() or f"Rumoca exited {result.returncode}")
    return json.loads(output.read_text(encoding="utf-8"))


def is_real_scalar(flat, variable):
    canonical = flat["effective_types"].get(str(variable["type_id"]), {}).get("canonical_type")
    return not variable["dims"] and canonical == flat["predefined_types"]["real"]


def verified_features(flat, review):
    variables = flat["variables"]
    parameters = review.get("parameters", {})
    defaults = review.get("modelicaDefaults", {})
    flanges = review.get("ports", {})
    signals = review.get("signals", {})
    inputs = review.get("inputs", {})
    if set(flat["top_level_connectors"]) != (flanges.keys() | signals.keys() | inputs.keys()):
        raise ValueError(f"unreviewed connector interface: {flat['top_level_connectors']}")

    top_parameters = {
        name for name, variable in variables.items()
        if len(variable["component_ref"]["parts"]) == 1 and "Parameter" in variable["variability"]
    }
    if top_parameters != (parameters.keys() | defaults.keys()):
        raise ValueError(f"unreviewed parameter interface: {sorted(top_parameters)}")
    for name, value in defaults.items():
        literal = variables[name].get("binding") or {}
        actual = literal.get("Literal", {}).get("value", {}).get("Boolean")
        if type(value) is not bool or actual is not value:
            raise ValueError(f"reviewed Boolean default for {name} is no longer {value}")

    ports, attributes, signal_defs = [], [], {}
    for name, alias in flanges.items():
        fields = {
            key.removeprefix(name + "."): variable
            for key, variable in variables.items()
            if key.startswith(name + ".")
        }
        members = frozenset((field, variable.get("unit")) for field, variable in fields.items())
        if members not in FLANGES or not all(is_real_scalar(flat, variable) for variable in fields.values()):
            raise ValueError(f"unsupported flange {name}: {sorted(fields)}")
        ports.append((alias, FLANGES[members]))
    for direction, mapping in (("Input", inputs), ("Output", signals)):
        for name, alias in mapping.items():
            variable = variables[name]
            unit = variable.get("unit")
            if direction not in variable["causality"] or not is_real_scalar(flat, variable) or unit not in SIGNALS:
                raise ValueError(f"unsupported {direction.lower()} {name} with unit {unit!r}")
            port, feature = SIGNALS[unit]
            if unit != "W":
                signal_defs[port] = (feature, QUANTITIES[unit])
            ports.append((alias, "~" + port if direction == "Input" else port))
            if direction == "Output":
                attributes.append((name, QUANTITIES[unit]))
    for name, alias in parameters.items():
        variable = variables[name]
        unit = variable.get("unit")
        if not unit and name in review.get("dimensionlessParameters", []):
            unit = "1"
        if not is_real_scalar(flat, variable) or unit not in QUANTITIES:
            raise ValueError(f"unsupported parameter {name} with unit {unit!r}")
        attributes.append((alias, QUANTITIES[unit]))
    return ports, attributes, signal_defs


def render_part(class_name, review, flat):
    ports, attributes, signal_defs = verified_features(flat, review)
    lines = [
        f"    part def {review['part']} :> MechanicalComponent {{",
        f"        doc /* {review['doc']} */",
        "        @Elan8::PhysicalModeling::ModelicaModel {",
        f'            className = "{class_name}";',
    ]
    pin_map = {**review.get("ports", {}), **review.get("inputs", {}), **review.get("signals", {})}
    for field, mapping in (("parameters", review.get("parameters", {})), ("pins", pin_map)):
        if mapping:
            pairs = ", ".join(f'"{alias}={name}"' for name, alias in mapping.items())
            lines.append(f"            {field} = ({pairs});")
    lines.append("        }")
    lines.extend(f"        port {name} : {kind};" for name, kind in ports)
    lines.extend(f"        attribute {name} : {kind};" for name, kind in attributes)
    lines.append("    }")
    return "\n".join(lines), signal_defs


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rumoca", required=True, type=Path)
    parser.add_argument("--msl", required=True, type=Path, help="the unpacked Modelica <version> directory")
    parser.add_argument("--check", action="store_true", help="fail on drift without updating the sources")
    parser.add_argument("--jobs", type=int, default=min(4, os.cpu_count() or 1), help="parallel Rumoca probes")
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    reviewed = json.loads(MANIFEST.read_text(encoding="utf-8"))
    msl = args.msl.resolve()
    version = re.search(r'^\s*version\s*=\s*"([^"]+)"', (msl / "package.mo").read_text(encoding="utf-8"), re.M)
    if not version:
        parser.error("cannot read the MSL package version")
    roots = [msl, msl.parent / "Complex.mo", msl.parent / f"ModelicaServices {version[1]}"]
    catalog = msl_catalog(msl)
    updates, selected, problems = {}, set(), []
    with tempfile.TemporaryDirectory() as scratch, ThreadPoolExecutor(max_workers=args.jobs) as pool:
        rumoca = args.rumoca.resolve()
        probes = {
            name: pool.submit(inspect_class, rumoca, roots, Path(scratch) / name, name)
            for classes in reviewed["files"].values()
            for name in classes
            if name in catalog
        }
        for relative, classes in reviewed["files"].items():
            parts, signal_defs = [], {}
            for class_name, review in classes.items():
                try:
                    if class_name not in catalog:
                        raise ValueError("class is missing from the MSL catalog")
                    flat = probes[class_name].result()
                    declaration, ports = render_part(class_name, review, flat)
                except (OSError, ValueError, KeyError, subprocess.TimeoutExpired) as error:
                    problems.append(f"{class_name} needs review: {error}")
                    continue
                parts.append(declaration)
                signal_defs.update(ports)
                selected.add(class_name)
            definitions = [
                f"    port def {port} {{\n        out attribute {name} : {kind};\n    }}"
                for port, (name, kind) in sorted(signal_defs.items())
            ]
            path = ROOT / relative
            original = path.read_text(encoding="utf-8")
            before, match, rest = original.partition(BEGIN + "\n")
            _, end, after = rest.partition("\n" + END)
            if not match or not end:
                parser.exit(1, f"{relative}: missing generated region markers\n")
            generated = before + match + "\n\n".join(definitions + parts) + end + after
            if original != generated:
                updates[path] = generated

    if problems:
        parser.exit(1, "\n".join(problems) + "\n")
    existing = {
        definition["binding"].get("className")
        for definitions in part_definitions().values()
        for definition in definitions
        if definition["binding"] and "examples" not in definition["file"].relative_to(ROOT).parts
    }
    pending = sorted(name for name in catalog - selected - existing if name.rsplit(".", 1)[0] in reviewed["catalogPackages"])
    print(f"{len(selected)} Mechanics bindings generated from MSL {version[1]}; {len(pending)} 1D classes need review.")
    for name in pending:
        print(f"  Review required: {name}")
    for path, source in updates.items():
        print(f"{'Stale' if args.check else 'Updated'}: {path.relative_to(ROOT)}")
        if not args.check:
            path.write_text(source, encoding="utf-8", newline="\n")
    return int(args.check and bool(updates))


if __name__ == "__main__":
    sys.exit(main())
