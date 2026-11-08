"""Check the Elan8Tests results against references derived without a simulator: closed-form
circuit solutions, and MSL's Ebers-Moll transistor equations solved with Newton's method.

    python3 check.py <directory with <Model>.csv>
"""
import csv
import math
import sys
from pathlib import Path

OUT = Path(sys.argv[1])
results = []


def load(name):
    with open(OUT / f"{name}.csv") as f:
        return [{k: float(v) for k, v in row.items()} for row in csv.DictReader(f)]


def check(name, worst, limit, what):
    ok = worst <= limit
    results.append(ok)
    print(f"{'PASS' if ok else 'FAIL'}  {name}: {what}: worst error {worst:.3g} (limit {limit:.3g})")


V0, RI, Q0 = 3.0, 15.0, 220e-3 * 3600 * 0.8

# PrimaryCell with 10 kOhm: i = V0/(Ri + R), remaining charge Q0 - i t.
rows = load("CellResistor")
i = V0 / (RI + 10000)
check("CellResistor", max(abs(r["cell.current"] - i) for r in rows), 1e-12, "current [A]")
check("CellResistor", max(abs(r["cell.remainingCharge"] - (Q0 - i * r["time"])) for r in rows), 1e-9, "remaining charge [C]")

# RC charging from 0 V: v = V (1 - exp(-t/RC)).
rows = load("RcCharge")
tau = 1000 * 1e-6
check("RcCharge", max(abs(r["capacitor.v"] - 3.0 * (1 - math.exp(-r["time"] / tau))) for r in rows), 1e-6, "capacitor voltage [V]")

# PrimaryCell delivering 3 mA: terminal voltage V0 - Ri I, remaining charge Q0 - I t.
rows = load("CellCurrentSource")
check("CellCurrentSource", max(abs(r["cell.positive.v"] - (V0 - RI * 3e-3)) for r in rows), 1e-12, "terminal voltage [V]")
check("CellCurrentSource", max(abs(r["cell.remainingCharge"] - (Q0 - 3e-3 * r["time"])) for r in rows), 1e-9, "remaining charge [C]")

# Transistor: MSL NPN static equations (no temperature dependency, substrate grounded).
IS, BF, BR, VAK, VT, G = 1e-16, 200.0, 0.1, 0.02, 0.02585, 1e-15


def driver(vrail=3.0, vdrive=3.0, rb=47000.0, rc=1000.0):
    """KCL at base and collector of a low-side NPN, solved for (vb, vc) by Newton's method."""

    def f(vb, vc):
        vbe, vbc = vb, vb - vc
        ibe = IS * (math.exp(vbe / VT) - 1) + vbe * G
        ibc = IS * (math.exp(vbc / VT) - 1) + vbc * G
        ic = (ibe - ibc) * (1 - vbc * VAK) - ibc / BR
        ib = ibe / BF + ibc / BR
        return ((vdrive - vb) / rb - ib, (vrail - vc) / rc - ic), ic

    vb, vc = 0.7, 0.1
    for _ in range(200):
        (f1, f2), _ = f(vb, vc)
        h = 1e-9
        (a1, a2), _ = f(vb + h, vc)
        (b1, b2), _ = f(vb, vc + h)
        j11, j21, j12, j22 = (a1 - f1) / h, (a2 - f2) / h, (b1 - f1) / h, (b2 - f2) / h
        det = j11 * j22 - j12 * j21
        dvb, dvc = (f1 * j22 - f2 * j12) / det, (j11 * f2 - j21 * f1) / det
        vb, vc = vb - dvb, vc - dvc
        if abs(dvb) + abs(dvc) < 1e-14:
            break
    return vb, vc, f(vb, vc)[1]


vb, vc, ic = driver()
settled = [r for r in load("NpnDriver") if r["time"] >= 1e-4]
check("NpnDriver", max(abs(r["transistor.collector.i"] - ic) for r in settled), 1e-9, "collector current [A]")
check("NpnDriver", max(abs(r["transistor.collector.v"] - vc) for r in settled), 1e-6, "collector voltage [V]")
# MSL's PNP is the NPN with every junction voltage and terminal current negated, so the
# mirrored circuit carries the same currents with the opposite sign, measured from the rail.
settled = [r for r in load("PnpDriver") if r["time"] >= 1e-4]
check("PnpDriver", max(abs(r["transistor.collector.i"] + ic) for r in settled), 1e-9, "collector current [A]")
check("PnpDriver", max(abs(r["transistor.collector.v"] - (3.0 - vc)) for r in settled), 1e-6, "collector voltage [V]")

# The mass-spring example (model/generic/physical-modeling/examples/mass-spring): released
# 0.1 m from rest, s(t) = 0.1 cos(sqrt(k/m) t) with k = 10 N/m and m = 1 kg.
rows = load("MassSpring")
omega = math.sqrt(10 / 1)
check("MassSpring", max(abs(r["s"] - 0.1 * math.cos(omega * r["time"])) for r in rows), 1e-6, "position [m]")

print(f"{sum(results)}/{len(results)} checks pass")
sys.exit(0 if all(results) else 1)
