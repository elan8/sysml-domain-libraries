"""A module usable through import or as a command-line script."""
import sys


def format_report(label: str) -> str:
    return f"Report: {label}"


def main(label: str) -> int:
    print(format_report(label))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1] if len(sys.argv) > 1 else "demo"))
