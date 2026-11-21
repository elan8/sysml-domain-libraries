"""Check the force-driven mass trace from Run42 or the Modelica reference fixture."""

import argparse
import csv
import math
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("trace", type=Path)
    parser.add_argument("--commanded", action="store_true", help="check the experiment driven by a 6 N command")
    args = parser.parse_args()
    with args.trace.open(encoding="utf-8", newline="") as stream:
        rows = list(csv.DictReader(stream))
    if len(rows) < 100:
        raise SystemExit(f"Expected at least 100 samples, got {len(rows)}")
    time = "t" if "t" in rows[0] else "time"
    if float(rows[0][time]) != 0 or not math.isclose(float(rows[-1][time]), 1, abs_tol=1e-9):
        raise SystemExit("The trace must span 0 to 1 s")

    errors = []
    for row in rows:
        seconds = float(row[time])
        if not math.isfinite(seconds):
            raise SystemExit("The trace contains a non-finite sample")
        if args.commanded:
            # A 6 N command acting on 2 kg gives constant acceleration of 3 m/s².
            expected = {
                "positionSensor.s": 1.5 * seconds**2,
                "speedSensor.v": 3 * seconds,
                "accelerationSensor.a": 3,
            }
        else:
            # Acceleration is 1 m/s² plus another 2 m/s² starting at 0.25 s.
            expected = {"positionSensor.s": 0.5 * seconds**2 + max(0, seconds - 0.25)**2}
        for signal, target in expected.items():
            actual = float(row[signal])
            if not math.isfinite(actual):
                raise SystemExit(f"{signal} contains a non-finite sample")
            error = abs(actual - target)
            if error > 1e-6:
                raise SystemExit(f"{signal} at {seconds:g} s: error {error:.3g} exceeds 1e-6")
            errors.append(error)
    worst = max(errors)
    print(f"Motion matched the analytical response for {len(rows)} samples (max error {worst:.3g} in SI units).")


if __name__ == "__main__":
    main()
