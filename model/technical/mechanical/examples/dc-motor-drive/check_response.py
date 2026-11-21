"""Check the Run42 CSV and verification verdict for the DC motor drive example."""

import argparse
import csv
import json
import math
from pathlib import Path


def reference(time):
    """Return the current (A) and speed (rad/s) from the zero-state step response."""
    voltage, step_time = 12.0, 0.1
    resistance, inductance = 2.0, 0.1
    inertia, damping, torque_constant = 0.01, 0.1, 0.1
    elapsed = max(0.0, time - step_time)

    # Eliminating current gives L J w'' + (L b + R J) w' + (R b + k²) w = k V.
    linear = resistance / inductance + damping / inertia
    constant = (resistance * damping + torque_constant**2) / (inductance * inertia)
    discriminant = math.sqrt(linear**2 - 4 * constant)
    slow = (-linear + discriminant) / 2
    fast = (-linear - discriminant) / 2
    steady_speed = torque_constant * voltage / (resistance * damping + torque_constant**2)
    slow_exp = math.exp(slow * elapsed)
    fast_exp = math.exp(fast * elapsed)
    speed = steady_speed * (1 + (fast * slow_exp - slow * fast_exp) / (slow - fast))
    acceleration = steady_speed * slow * fast * (slow_exp - fast_exp) / (slow - fast)
    current = (inertia * acceleration + damping * speed) / torque_constant
    return current, speed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("trace", type=Path)
    parser.add_argument("verdicts", type=Path)
    args = parser.parse_args()
    with args.trace.open(encoding="utf-8", newline="") as trace:
        reader = csv.DictReader(trace)
        observed = list(reader)
    if len(observed) != 201:
        raise SystemExit(f"Expected 201 samples, got {len(observed)}")

    for index, row in enumerate(observed):
        time = float(row["t"])
        if not math.isclose(time, index / 200, rel_tol=0, abs_tol=1e-10):
            raise SystemExit(f"Unexpected sample time {time} at row {index}")
        for column, expected in zip(("ammeter.i", "tachometer.w"), reference(time)):
            actual = float(row[column])
            if not math.isclose(actual, expected, rel_tol=0, abs_tol=2e-4):
                raise SystemExit(f"At {time:g} s, {column} was {actual:.8g}, expected {expected:.8g}")

    records = json.loads(args.verdicts.read_text(encoding="utf-8"))
    cases = [case for case in records if case["case_name"] == "DcMotorDrive::operatingSpeedTest"]
    if len(cases) != 1 or any(
        cases[0].get(key) != value
        for key, value in (
            ("verdict", "pass"),
            ("backend", "modelica"),
            ("requirements", ["DcMotorDrive::reachesOperatingSpeed"]),
        )
    ):
        raise SystemExit(f"Expected one passing Modelica result for the speed requirement, got {cases}")
    print("Armature current, shaft speed and verification verdict match the reference.")


if __name__ == "__main__":
    main()
