# DC motor driving a damped shaft

A 12 V step at 0.1 s drives a brushed motor and a rigid load with viscous damping.
The ammeter measures the armature current and the tachometer measures shaft speed.
The example uses the Elan8 domain libraries and Modelica Standard Library 4.1.0.

From the domain-library repository root, run these commands with a Run42 installation
that includes the Elan8 Modelica package from domain libraries v0.8.0 or a compatible
later release.
For a development installation, `RUN42_ENGINES` can point to a directory containing
both Run42's `msl` directory and this repository's `modelica/Elan8` package as `Elan8`.

```bash
run42 run model/technical/mechanical/examples/dc-motor-drive model --root DcMotorDrive::Drive --t-end 1s --points 201 --rtol 1e-9 --atol 1e-11 --out drive
run42 verify model/technical/mechanical/examples/dc-motor-drive model --out verdicts.json
python model/technical/mechanical/examples/dc-motor-drive/check_response.py drive.csv verdicts.json
```

The total inertia \(J\) is 0.010 kg·m² and the damping \(b\) is 0.1 N·m·s/rad.
With armature resistance \(R\), inductance \(L\) and torque constant \(k\),
the reference follows from \(L \dot i + Ri + k\omega = V\) and
\(J \dot\omega + b\omega = ki\). The steady-state speed for a 12 V supply is
\(kV/(Rb+k^2)\), about 5.714 rad/s. The checker compares both traces with the
closed-form solution and checks that the speed requirement passed in Run42.
