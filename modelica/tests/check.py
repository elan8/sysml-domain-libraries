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

# Mass released from 0.1 m at rest on a spring (c = 100 N/m) and damper (d = 4 N s/m), m = 1 kg:
# w0 = 10 rad/s, zeta = 0.2, so s(t) = 0.1 exp(-2 t) (cos(wd t) + 2/wd sin(wd t)), wd = sqrt(96).
rows = load("MassSpringDamper")
wd = math.sqrt(96)
check("MassSpringDamper", max(abs(r["body.s"] - 0.1 * math.exp(-2 * r["time"]) * (math.cos(wd * r["time"]) + 2 / wd * math.sin(wd * r["time"]))) for r in rows), 1e-6, "position [m]")

def linear_motor(volts, resistance, inductance, k, inertia, t):
    """(armature current, shaft speed) at time t of L di/dt = V - R i - k w, J dw/dt = k i, from rest.
    Solved in closed form: x' = A x + b has x(t) = x_ss + exp(A t) (x(0) - x_ss), and for a 2 x 2 matrix
    with distinct real eigenvalues l1, l2, exp(A t) = (e^(l1 t) (A - l2 I) - e^(l2 t) (A - l1 I)) / (l1 - l2)."""
    a, b = [[-resistance / inductance, -k / inductance], [k / inertia, 0.0]], [volts / inductance, 0.0]
    trace, det = a[0][0] + a[1][1], a[0][0] * a[1][1] - a[0][1] * a[1][0]
    root = math.sqrt(trace * trace - 4 * det)
    l1, l2 = (trace + root) / 2, (trace - root) / 2
    steady = [-(a[1][1] * b[0] - a[0][1] * b[1]) / det, -(-a[1][0] * b[0] + a[0][0] * b[1]) / det]
    x0 = [-steady[0], -steady[1]]

    def term(lam, other):
        return [[math.exp(lam * t) * (a[i][j] - (other if i == j else 0)) for j in range(2)] for i in range(2)]

    m1, m2 = term(l1, l2), term(l2, l1)
    return [steady[i] + sum((m1[i][j] - m2[i][j]) / (l1 - l2) * x0[j] for j in range(2)) for i in range(2)]


# Motor (R = 2 ohm, L = 5 mH, k = 0.05 N m/A, rotor 1e-4 kg m2) plus a 2e-4 kg m2 load, from rest on 12 V.
rows = load("DcMotorSpinUp")
check("DcMotorSpinUp", max(abs(r["load.w"] - linear_motor(12, 2, 5e-3, 0.05, 3e-4, r["time"])[1]) for r in rows), 1e-4, "shaft speed [rad/s]")
check("DcMotorSpinUp", max(abs(r["motor.winding.i"] - linear_motor(12, 2, 5e-3, 0.05, 3e-4, r["time"])[0]) for r in rows), 1e-6, "armature current [A]")

# The same motor behind a 10:1 gear and a 30 mm wheel on a 1 kg body. With w_wheel = w_motor / 10 and
# v = 0.03 w_wheel, the body's kinetic energy M v^2 / 2 refers to the motor shaft as an inertia
# M (0.03 / 10)^2, so the motor sees J = 1e-4 + 9e-6 and the body's speed is 0.003 times the motor's.
J = 1e-4 + 1.0 * (0.03 / 10) ** 2
rows = load("DriveWheel")
check("DriveWheel", max(abs(r["body.v"] - 0.003 * linear_motor(12, 2, 5e-3, 0.05, J, r["time"])[1]) for r in rows), 1e-6, "body speed [m/s]")
check("DriveWheel", max(abs(r["motor.winding.i"] - linear_motor(12, 2, 5e-3, 0.05, J, r["time"])[0]) for r in rows), 1e-6, "armature current [A]")

# Inertia J = 0.01 kg m2 released 0.1 rad on a spring c = 1 N m/rad and damper d = 0.04 N m s/rad:
# w0 = sqrt(c/J) = 10 rad/s, zeta = d / (2 sqrt(c J)) = 0.2, so phi(t) = 0.1 exp(-2 t) (cos(wd t) + 2/wd sin(wd t)).
rows = load("TorsionalOscillator")
check("TorsionalOscillator", max(abs(r["rotor.phi"] - 0.1 * math.exp(-2 * r["time"]) * (math.cos(wd * r["time"]) + 2 / wd * math.sin(wd * r["time"]))) for r in rows), 1e-6, "angle [rad]")

# A constant torque tau on an inertia J from rest: w = tau t / J.
rows = load("TorqueSpinUp")
check("TorqueSpinUp", max(abs(r["rotor.w"] - 0.5 * r["time"] / 0.25) for r in rows), 1e-9, "angular velocity [rad/s]")

# Transistor: MSL NPN static equations (no temperature dependency, substrate grounded).
IS, BF, BR, VAK, VT, G = 1e-16, 200.0, 0.1, 0.02, 0.02585, 1e-15


# PermanentMagnetSynchronousMotor, R = 0.5 ohm, Ld = 1 mH, Lq = 2 mH, flux 0.05 Wb, 4 pole pairs.
# With the rotor held the electrical speed is zero, so each axis is a first-order circuit.
R_S, L_D, L_Q, PSI, P_P, J_TOTAL = 0.5, 1e-3, 2e-3, 0.05, 4, 2e-3
rows = load("PmsmLockedRotor")
id_ = lambda t: 3 / R_S * (1 - math.exp(-R_S * t / L_D))
iq_ = lambda t: 5 / R_S * (1 - math.exp(-R_S * t / L_Q))
check("PmsmLockedRotor", max(abs(r["motor.id"] - id_(r["time"])) for r in rows), 1e-6, "d-axis current [A]")
check("PmsmLockedRotor", max(abs(r["motor.iq"] - iq_(r["time"])) for r in rows), 1e-6, "q-axis current [A]")
check("PmsmLockedRotor", max(abs(r["motor.electricalTorque"] - 1.5 * P_P * (PSI * iq_(r["time"]) + (L_D - L_Q) * id_(r["time"]) * iq_(r["time"]))) for r in rows), 1e-6, "torque [N m]")


def pmsm_free_spin(vd, vq, t_end, step=1e-6):
    """Classical fourth-order Runge-Kutta, written here and not taken from a simulator."""
    def f(x):
        i_d, i_q, w = x
        we = P_P * w
        torque = 1.5 * P_P * (PSI * i_q + (L_D - L_Q) * i_d * i_q)
        return [(vd - R_S * i_d + we * L_Q * i_q) / L_D, (vq - R_S * i_q - we * (L_D * i_d + PSI)) / L_Q, torque / J_TOTAL]
    x, t, out = [0.0, 0.0, 0.0], 0.0, {}
    while t < t_end - 1e-12:
        k1 = f(x)
        k2 = f([a + step / 2 * b for a, b in zip(x, k1)])
        k3 = f([a + step / 2 * b for a, b in zip(x, k2)])
        k4 = f([a + step * b for a, b in zip(x, k3)])
        x = [a + step / 6 * (b + 2 * c + 2 * d + e) for a, b, c, d, e in zip(x, k1, k2, k3, k4)]
        t += step
        out[round(t, 6)] = tuple(x)
    return out


# Salient motor from rest on vd = -2 V, vq = 10 V, free on a 1e-3 kg m2 load. The d and q axes couple
# through the speed, so the reference is an independent integration.
rows = load("PmsmFreeSpin")
ref = pmsm_free_spin(-2, 10, 0.1)
sampled = [r for r in rows if round(r["time"], 6) in ref and r["time"] > 0]
assert len(sampled) > 100, "the free-spin check must compare many samples"
check("PmsmFreeSpin", max(abs(r["motor.id"] - ref[round(r["time"], 6)][0]) for r in sampled), 1e-4, "d-axis current [A]")
check("PmsmFreeSpin", max(abs(r["motor.iq"] - ref[round(r["time"], 6)][1]) for r in sampled), 1e-4, "q-axis current [A]")
check("PmsmFreeSpin", max(abs(r["load.w"] - ref[round(r["time"], 6)][2]) for r in sampled), 1e-3, "shaft speed [rad/s]")


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
check("NpnDriver", max(abs(r["transistor.C.i"] - ic) for r in settled), 1e-9, "collector current [A]")
check("NpnDriver", max(abs(r["transistor.C.v"] - vc) for r in settled), 1e-6, "collector voltage [V]")
# MSL's PNP is the NPN with every junction voltage and terminal current negated, so the
# mirrored circuit carries the same currents with the opposite sign, measured from the rail.
settled = [r for r in load("PnpDriver") if r["time"] >= 1e-4]
check("PnpDriver", max(abs(r["transistor.C.i"] + ic) for r in settled), 1e-9, "collector current [A]")
check("PnpDriver", max(abs(r["transistor.C.v"] - (3.0 - vc)) for r in settled), 1e-6, "collector voltage [V]")

# The mass-spring example (model/generic/physical-modeling/examples/mass-spring): released
# 0.1 m from rest, s(t) = 0.1 cos(sqrt(k/m) t) with k = 10 N/m and m = 1 kg.
rows = load("MassSpring")
omega = math.sqrt(10 / 1)
check("MassSpring", max(abs(r["s"] - 0.1 * math.cos(omega * r["time"])) for r in rows), 1e-6, "position [m]")

print(f"{sum(results)}/{len(results)} checks pass")
sys.exit(0 if all(results) else 1)
