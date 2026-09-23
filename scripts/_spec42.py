"""Shared helpers for locating the spec42 CLI and its library-path arguments.

Used by validate_spec42.py.
"""
from __future__ import annotations

import os
import shutil
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent


def find_spec42(explicit: str | None = None) -> str:
    """Resolve the spec42 executable.

    Priority: explicit --spec42 argument > SPEC42_EXE env var > a sibling
    elan8/spec42 checkout's built binary > spec42 on PATH.
    """
    if explicit:
        return explicit
    env = os.environ.get("SPEC42_EXE")
    if env:
        return env
    for profile in ("release", "debug"):
        for name in ("spec42", "spec42.exe"):
            candidate = REPO_ROOT.parent / "spec42" / "target" / profile / name
            if candidate.is_file():
                return str(candidate)
    found = shutil.which("spec42")
    if found:
        return found
    raise SystemExit(
        "Could not find the spec42 executable. Set SPEC42_EXE, pass --spec42, "
        "or build a sibling elan8/spec42 checkout (cargo build --release -p spec42)."
    )


def library_path_args() -> list[str]:
    """--library-path arguments for this repo's own domain/technical/generic libraries.

    Disables the domain/method managed KPAR libraries so they don't collide
    with the raw --library-path sources below (both would otherwise resolve
    the same namespaces and be reported ambiguous).
    """
    args = [
        "--disable-kpar-library", "domain",
        "--disable-kpar-library", "method",
    ]
    for sub in ("domain", "technical", "generic"):
        path = REPO_ROOT / sub
        if path.is_dir():
            args += ["--library-path", str(path)]
    return args
