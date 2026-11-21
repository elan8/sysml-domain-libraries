# Force-driven mass

A 2 kg body starts at rest under a 2 N force. A second source adds 4 N at 0.25 s.
The position sensor measures the body without adding a load. The sources and
sensor come from the Mechanics binding generator.

From the domain-library repository root:

```bash
run42 run model/technical/mechanical/examples/force-driven-mass model \
  --root ForceDrivenMass::Experiment --t-end 1s --points 101 \
  --rtol 1e-9 --atol 1e-12 --out force-driven-mass
python3 model/technical/mechanical/examples/force-driven-mass/check_position.py force-driven-mass.csv
```

The reference comes from integrating the piecewise constant acceleration
\(F/m\) twice. Position in metres is \(0.5t^2 + \max(0,t-0.25)^2\), where
\(t\) is in seconds. The Modelica CI fixture uses the same setup and checker.

`CommandedExperiment` uses a signal-controlled force source and measures
position, speed, and acceleration under a constant external command:

```bash
run42 run model/technical/mechanical/examples/force-driven-mass model \
  --root ForceDrivenMass::CommandedExperiment --input 'f=6[N]' --t-end 1s \
  --points 101 --rtol 1e-9 --atol 1e-12 --out commanded-force
python3 model/technical/mechanical/examples/force-driven-mass/check_position.py commanded-force.csv --commanded
```
