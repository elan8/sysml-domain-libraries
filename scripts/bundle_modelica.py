#!/usr/bin/env python3
"""Bundle the Modelica package (`modelica/Elan8`) of the domain libraries into a ZIP.

The SysML libraries ship as a KPAR (`bundle_kpar.py`), which holds model files only. The
Modelica classes that the SysML parts bind to are published next to it as
`<name>-modelica-<version>.zip`, from the same tag. The archive holds `Elan8/` and the licence
at its root, so unpacking it into a `modelica/` directory makes `modelica://Elan8` resolve.
The numerical checks under `modelica/tests` are not part of it.

The archive is reproducible: entries are sorted and carry a fixed timestamp and mode, so the
same tag always gives the same bytes. Symbolic links are refused.

Usage:
    python3 scripts/bundle_modelica.py
    python3 scripts/bundle_modelica.py --version 0.7.0 --output elan8-domain-modelica-0.7.0.zip
"""
from __future__ import annotations

import argparse
import json
import sys
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PROJECT_FILE = REPO_ROOT / ".project.json"
PACKAGE = REPO_ROOT / "modelica" / "Elan8"
LICENSE = REPO_ROOT / "LICENSE"
TIMESTAMP = (2020, 1, 1, 0, 0, 0)


def members() -> list[tuple[str, Path]]:
    if not (PACKAGE / "package.mo").is_file():
        raise SystemExit(f"{PACKAGE} is not a Modelica package (no package.mo)")
    files = []
    for path in sorted(PACKAGE.rglob("*")):
        if path.is_symlink():
            raise SystemExit(f"refusing symbolic link {path}")
        if path.is_file():
            files.append((f"Elan8/{path.relative_to(PACKAGE).as_posix()}", path))
    if LICENSE.is_file():
        files.append(("LICENSE", LICENSE))
    return files


def write(output: Path) -> int:
    count = 0
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, path in members():
            entry = zipfile.ZipInfo(name, TIMESTAMP)
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.external_attr = 0o644 << 16
            # Normalize line endings so a Windows checkout packs the same bytes.
            data = path.read_bytes()
            if path.suffix in {".mo", ".order"} or path.name == "LICENSE":
                data = data.replace(b"\r\n", b"\n")
            archive.writestr(entry, data)
            count += 1
    return count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--version",
        help="Expected library version (for example the release tag without `v`); "
        "fails when .project.json disagrees.",
    )
    parser.add_argument("--output", help="Archive to create (default: <name>-modelica-<version>.zip)")
    args = parser.parse_args()

    project = json.loads(PROJECT_FILE.read_text(encoding="utf-8"))
    version = project["version"]
    if args.version and args.version != version:
        print(
            f"{PROJECT_FILE.relative_to(REPO_ROOT)} has version {version}, "
            f"but {args.version} was requested.",
            file=sys.stderr,
        )
        return 1
    stem = project["name"].replace("-libraries", "")
    output = Path(args.output or f"{stem}-modelica-{version}.zip").resolve()
    count = write(output)
    print(f"Wrote {output.name}: {count} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
