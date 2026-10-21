#!/usr/bin/env python3
"""Bundle this repository's domain libraries into a KPAR with `spec42 bundle`.

The archive takes its name and version from `.project.json` at the repository root, the same
file Spec42's own library fetch script requires, and contains the libraries under `model/`. It
leaves out the documentation, scripts and examples (`examples/` directories and
`model/Examples.sysml`), as earlier releases did. Spec42 is the
release pinned in `.spec42-version` unless --spec42 or SPEC42_EXE names another executable.

Usage:
    python3 scripts/bundle_kpar.py
    python3 scripts/bundle_kpar.py --version 0.5.0 --output elan8-domain-libraries-0.5.0.kpar
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _spec42 import REPO_ROOT, find_spec42  # noqa: E402

PROJECT_FILE = REPO_ROOT / ".project.json"
EXCLUDES = [".git", "docs", "scripts", "examples", "model/Examples.sysml"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--spec42", help="Path to the spec42 executable")
    parser.add_argument(
        "--version",
        help="Expected library version (for example the release tag without `v`); "
        "fails when .project.json disagrees.",
    )
    parser.add_argument("--output", help="Archive to create (default: <name>-<version>.kpar)")
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
    output = Path(args.output or f"{project['name']}-{version}.kpar").resolve()

    command = [find_spec42(args.spec42), "bundle", str(REPO_ROOT), "--output", str(output)]
    for exclude in EXCLUDES:
        command += ["--exclude", exclude]
    return subprocess.run(command).returncode


if __name__ == "__main__":
    raise SystemExit(main())
