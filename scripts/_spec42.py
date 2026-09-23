"""Shared helpers for locating the spec42 CLI and its library-path arguments.

Used by validate_spec42.py.
"""
from __future__ import annotations

import os
import platform
import shutil
import stat
import tarfile
import urllib.request
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
VERSION_FILE = REPO_ROOT / ".spec42-version"


def _pinned_version() -> str:
    if not VERSION_FILE.is_file():
        raise SystemExit(
            f"Missing {VERSION_FILE}; cannot determine which spec42 release to download."
        )
    return VERSION_FILE.read_text(encoding="utf-8").strip()


def _cache_root() -> Path:
    if os.name == "nt":
        base = Path(os.environ.get("LOCALAPPDATA", Path.home() / "AppData" / "Local"))
    else:
        base = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))
    return base / "elan8" / "spec42"


def _platform_asset() -> tuple[str, str, str]:
    """(platform tag, archive extension, binary filename) for the current OS/arch."""
    system = platform.system()
    machine = platform.machine().lower()
    if system == "Linux" and machine in ("x86_64", "amd64"):
        return "linux-x64", "tar.gz", "spec42"
    if system == "Darwin" and machine in ("x86_64", "amd64"):
        return "darwin-x64", "tar.gz", "spec42"
    if system == "Darwin" and machine in ("arm64", "aarch64"):
        return "darwin-arm64", "tar.gz", "spec42"
    if system == "Windows" and machine in ("amd64", "x86_64"):
        return "win32-x64", "zip", "spec42.exe"
    raise SystemExit(
        f"No prebuilt spec42 release for {system}/{machine}. "
        "Build spec42 yourself and point SPEC42_EXE at it, or put spec42 on PATH."
    )


def _download(url: str, dest: Path) -> None:
    request = urllib.request.Request(url, headers={"User-Agent": "elan8-spec42-installer"})
    last_error: Exception | None = None
    for attempt in range(3):
        try:
            with urllib.request.urlopen(request) as response, open(dest, "wb") as out_file:
                shutil.copyfileobj(response, out_file)
            return
        except OSError as error:  # network hiccup, transient GitHub 5xx, etc.
            last_error = error
    raise SystemExit(f"Failed to download {url} after 3 attempts: {last_error}")


def _download_pinned_release() -> str:
    version = _pinned_version()
    platform_tag, archive_ext, binary_name = _platform_asset()
    install_dir = _cache_root() / version / platform_tag
    executable = install_dir / binary_name
    if executable.is_file():
        return str(executable)

    version_number = version.lstrip("v")
    archive_name = f"spec42-{version_number}-{platform_tag}.{archive_ext}"
    url = f"https://github.com/elan8/spec42/releases/download/{version}/{archive_name}"
    install_dir.mkdir(parents=True, exist_ok=True)
    archive_path = install_dir / archive_name

    print(f"spec42 not found on PATH or via SPEC42_EXE; downloading {url}")
    _download(url, archive_path)

    if archive_ext == "zip":
        with zipfile.ZipFile(archive_path) as archive:
            archive.extractall(install_dir)
    else:
        with tarfile.open(archive_path) as archive:
            try:
                archive.extractall(install_dir, filter="data")
            except TypeError:
                # Python < 3.8.17/3.9.17/3.10.12/3.11.4 lacks the PEP 706
                # `filter` argument. Fine here: the archive comes from a
                # pinned, trusted GitHub Releases URL, not arbitrary input.
                archive.extractall(install_dir)
    archive_path.unlink()

    if not executable.is_file():
        raise SystemExit(f"Expected {executable} after extracting {archive_name}, but it is missing.")
    mode = executable.stat().st_mode
    executable.chmod(mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)
    return str(executable)


def find_spec42(explicit: str | None = None) -> str:
    """Resolve the spec42 executable.

    Priority: explicit --spec42 argument > SPEC42_EXE env var > spec42 on
    PATH > download-and-cache the release pinned in .spec42-version.

    The download is cached under a user cache directory keyed by version and
    platform, so it only happens once per machine per spec42 release.
    """
    if explicit:
        return explicit
    env = os.environ.get("SPEC42_EXE")
    if env:
        return env
    found = shutil.which("spec42")
    if found:
        return found
    return _download_pinned_release()


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
