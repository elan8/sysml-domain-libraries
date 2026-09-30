#!/usr/bin/env python3
"""Run `spec42 check` over this repository, filtering advisory diagnostics.

Python replacement for the old validate-spec42.ps1 (this repo's tooling no
longer depends on PowerShell). By default, diagnostics with `source =
domain` are filtered out of the pass/fail result: those are modeling-
completeness checks from Spec42's bundled domain libraries, not SysML
syntax or semantic validity checks for this repository. Pass
--include-domain-diagnostics to see them.

Usage:
    python3 scripts/validate_spec42.py
    python3 scripts/validate_spec42.py --format json
    python3 scripts/validate_spec42.py --include-domain-diagnostics --format sarif
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _spec42 import REPO_ROOT, find_spec42, library_path_args  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--spec42", help="Path to the spec42 executable")
    parser.add_argument(
        "--format", choices=["text", "json", "sarif", "junit"], default="text"
    )
    parser.add_argument(
        "--include-domain-diagnostics",
        action="store_true",
        help="Include Spec42's bundled domain-completeness diagnostics (source=domain) "
        "instead of filtering them out of the result.",
    )
    args = parser.parse_args()

    spec42 = find_spec42(args.spec42)
    base_command = [
        spec42,
        *library_path_args(),
        "check",
        str(REPO_ROOT),
        "--workspace-root",
        str(REPO_ROOT),
    ]

    if args.include_domain_diagnostics:
        return subprocess.run([*base_command, "--format", args.format]).returncode

    if args.format not in ("text", "json"):
        parser.error(
            "Filtered validation supports --format text or json. Use "
            "--include-domain-diagnostics for raw sarif or junit output."
        )

    result = subprocess.run(
        [*base_command, "--format", "json"], capture_output=True, text=True
    )
    report = json.loads(result.stdout)

    error_count = warning_count = information_count = 0
    for document in report["documents"]:
        kept = []
        for diagnostic in document.get("diagnostics", []):
            if diagnostic.get("source") == "domain":
                continue
            kept.append(diagnostic)
            severity = diagnostic.get("severity")
            if severity == 1:
                error_count += 1
            elif severity == 2:
                warning_count += 1
            elif severity == 3:
                information_count += 1
        document["diagnostics"] = kept

    report["summary"]["error_count"] = error_count
    report["summary"]["warning_count"] = warning_count
    report["summary"]["information_count"] = information_count

    if args.format == "json":
        print(json.dumps(report, indent=2))
    else:
        print(
            f"Spec42 SysML validation: {report['summary']['document_count']} documents, "
            f"{error_count} errors, {warning_count} warnings, {information_count} information."
        )
        print(
            "Domain completeness diagnostics were filtered. Re-run with "
            "--include-domain-diagnostics to include them."
        )

    return 1 if (error_count > 0 or warning_count > 0) else 0


if __name__ == "__main__":
    raise SystemExit(main())
