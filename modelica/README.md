# Modelica behaviour of the domain libraries

A part definition gets its physics from a Modelica class, named with
`@Elan8::PhysicalModeling::ModelicaModel` (see
[`PhysicalModeling`](../model/generic/physical-modeling/README.md)). Most parts bind to the
Modelica Standard Library (MSL), at the version `package.mo` declares with `uses`; this directory holds the `Elan8` Modelica package
for the few the MSL has no class for.

| Part definition | Modelica class |
| --- | --- |
| `Components::Resistor` | `Modelica.Electrical.Analog.Basic.Resistor` |
| `Components::Capacitor` | `Modelica.Electrical.Analog.Basic.Capacitor` |
| `Components::Inductor` | `Modelica.Electrical.Analog.Basic.Inductor` |
| `Components::VoltageSource` | `Modelica.Electrical.Analog.Sources.ConstantVoltage` |
| `Components::SignalControlledVoltageSource` | `Modelica.Electrical.Analog.Sources.SignalVoltage` |
| `Components::StepVoltageSource` | `Modelica.Electrical.Analog.Sources.StepVoltage` |
| `Components::CurrentSource` | `Modelica.Electrical.Analog.Sources.ConstantCurrent` |
| `Components::CurrentSensor` | `Modelica.Electrical.Analog.Sensors.CurrentSensor` |
| `Components::Ground` | `Modelica.Electrical.Analog.Basic.Ground` |
| `Components::NpnTransistor` | `Modelica.Electrical.Analog.Semiconductors.NPN` |
| `Components::PnpTransistor` | `Modelica.Electrical.Analog.Semiconductors.PNP` |
| `Power::PrimaryCell` | `Elan8.Electronics.Power.PrimaryCell` (this directory) |
| `Translational::Mass` | `Modelica.Mechanics.Translational.Components.Mass` |
| `Translational::Spring` | `Modelica.Mechanics.Translational.Components.Spring` |
| `Translational::Damper` | `Modelica.Mechanics.Translational.Components.Damper` |
| `Translational::FixedSupport` | `Modelica.Mechanics.Translational.Components.Fixed` |
| `Rotational::Inertia` | `Modelica.Mechanics.Rotational.Components.Inertia` |
| `Rotational::TorsionalSpring` | `Modelica.Mechanics.Rotational.Components.Spring` |
| `Rotational::TorsionalDamper` | `Modelica.Mechanics.Rotational.Components.Damper` |
| `Rotational::RotationalFixedSupport` | `Modelica.Mechanics.Rotational.Components.Fixed` |
| `Rotational::TorqueSource` | `Modelica.Mechanics.Rotational.Sources.ConstantTorque` |
| `Rotational::ShaftSpeedSensor` | `Modelica.Mechanics.Rotational.Sensors.SpeedSensor` |
| `Drivetrain::Gearbox` | `Modelica.Mechanics.Rotational.Components.IdealGear` |
| `Drivetrain::RollingWheel` | `Modelica.Mechanics.Rotational.Components.IdealRollingWheel` |
| `Actuation::BrushedDcMotor` | `Elan8.Electronics.Actuation.BrushedDcMotor` (this directory) |
| `Actuation::PermanentMagnetSynchronousMotor` | `Elan8.Electronics.Actuation.PermanentMagnetSynchronousMotor` (this directory) |
| `Actuation::BldcMotor` | `Elan8.Electronics.Actuation.ThreePhaseBldcMotor` (this directory) |
| `Balancing::WheeledInvertedPendulum` | `Elan8.Mechanical.WheeledInvertedPendulum` (this directory) |
| `Actuation::RotationalElectromechanicalConverter` | `Modelica.Electrical.Analog.Basic.RotationalEMF` |

The [DC motor drive](../model/technical/mechanical/examples/dc-motor-drive/README.md) composes
the brushed motor, a step voltage source, a rotational load and two sensors in SysML.

Specializations use their supertype's binding: a `TantalumCapacitor` is a
`Modelica.Electrical.Analog.Basic.Capacitor`. Parts without a binding, such as `Diode`
(whose ratings are not the MSL diode's parameters), are not simulated.

`BrushedDcMotor` has its own class because the MSL's DC machine is a loss and thermal model whose
parameters are a datasheet's nominal point, not the plain resistance, inductance, torque constant
and rotor inertia that sizing a drive starts from. The class composes MSL elements: a `Resistor`, an
`Inductor`, a `RotationalEMF` and an `Inertia`. It is also the torque-level equivalent of a brushless
or permanent-magnet synchronous motor under ideal commutation or field-oriented control. The two
three-phase classes model such motors themselves: `PermanentMagnetSynchronousMotor` in the rotor's dq
frame, and `ThreePhaseBldcMotor` phase by phase on an averaged inverter.

`WheeledInvertedPendulum` is a body balanced on one axle with two wheels that roll without slipping, in
the vertical plane, with the motors acting between the wheels and the body (the `drive` flange: a torque
on the wheels, the opposite torque on the body). It is written out from Lagrange's equations in the
position and the pitch, with the two accelerations solved explicitly, because the compiler the
numerical checks use does not accept the coupled 2x2 system as an implicit block. A MultiBody model of the
same system is a possible cross-check, but with that compiler a `BodyShape` simulates without error and
never moves, so MultiBody models there use `Body` and need a reference solution.

## Initial values

A SysML attribute paired with a Modelica *variable* instead of a parameter names a state of
the component: `Translational::Mass` pairs `position` with `s` and `velocity` with `v`. A
simulation tool starts that state at the attribute's initial value, written with `:=`, and at
the Modelica class's default when there is none. `=` binds a parameter, so it is an error on a
state:

```sysml
part body : Mass {
    attribute :>> mass = 1 [kg];            // parameter m
    attribute :>> position := 0.1 [m];      // state s, starts at 0.1 m
}
```

See [`examples/mass-spring-damper`](../model/technical/mechanical/examples/mass-spring-damper/mass-spring-damper.sysml).

## Names

A binding pairs names with `parameters` and `pins`, as "sysmlName=modelicaName":

```sysml
part def Resistor :> TwoTerminalPassiveComponent {
    @Elan8::PhysicalModeling::ModelicaModel {
        className = "Modelica.Electrical.Analog.Basic.Resistor";
        parameters = ("resistance=R");
        pins = ("terminal1=p", "terminal2=n");
    }
    attribute resistance : ResistanceValue;
}
```

Names that are the same on both sides need no entry, so the `Elan8` classes use the SysML
names. Modelica parameters left unpaired keep their defaults; every parameter without a
default and every pin must be paired.

## Checks

```bash
modelica/tests/run.sh
```

downloads the pinned rumoca release and MSL into `modelica/tests/.cache` (needs `gh`), checks
every binding against its class (`scripts/check_modelica_bindings.py`), then simulates small
circuits of the bound classes (`tests/Elan8Tests.mo`) and the mass-spring example, and
compares the results with references derived without a simulator (`tests/check.py`):
closed-form circuit solutions, and the MSL transistor's Ebers-Moll equations solved with
Newton's method. This directory is not part of the KPAR bundle.

## MSL binding coverage

The Modelica CI job publishes covered and missing class counts by MSL domain.
Expand a domain in the job summary to see the names of both sets, grouped by
package. The comparison scans the pinned MSL release for public, non-partial
models and blocks declared in packages. It excludes `Resources` source files
and classes under `BaseClasses`, `Examples`, `Icons`, `Interfaces`, `Internal`,
and `UsersGuide`.

An MSL class counts as covered when a reusable domain-library part binds directly
to it and passes the binding check. The reference simulations exercise individual
models separately.

CI checks every class listed in [the coverage baseline](tests/msl-coverage-baseline.txt).
New bindings appear in the report automatically. Add a class to the baseline when
its continued availability should be checked in CI.

To generate the same report locally using the pinned MSL release:

```bash
python3 scripts/check_modelica_bindings.py --msl "/path/to/Modelica 4.1.0" \
  --coverage-report msl-coverage.md --coverage-baseline modelica/tests/msl-coverage-baseline.txt
```

## Mechanics binding generator

[The reviewed mappings](mechanics-pilot.json) select MSL classes and name their
SysML parts, ports, and parameters. Rumoca 0.10.4 resolves inherited connectors,
parameter types, units, and defaults. The generator verifies the reviewed
mappings against that interface and updates only the marked regions of the
rotational and translational libraries. The force sources use the MSL default
of a fixed support. Changes to that default or to the resolved connector or
parameter inventory require review.

```bash
python3 -B scripts/generate_mechanics_bindings.py --rumoca /path/to/rumoca \
  --msl "/path/to/Modelica 4.1.0"
```

CI runs the same command with `--check` to detect drift in the committed
definitions. The command lists outstanding classes across the 1D components,
sensors, and sources packages. Validated bindings appear in the MSL coverage
table. The CI summary also records successful Modelica reference simulations.
The [force-driven mass](../model/technical/mechanical/examples/force-driven-mass/README.md)
exercises constant, step, and signal-controlled forces and measured motion
through SysML and Run42.

### MultiBody and advanced 1D interfaces

Rumoca 0.10.4 can run the MSL elementary pendulum as a precomposed Modelica
model. That assembly declares an `inner World` and supplies three-element
vectors for the revolute axis and body centre of mass. To compose it from
SysML parts, Run42 needs a way to declare the shared world at assembly scope,
pass dimensioned vector parameters, and map a typed 3D frame connection.

Completing the 1D catalog also requires array inputs for the `Move` sources,
configurable friction and loss tables, and verified conditional connector
configurations. The coverage report continues to list these classes until they
have validated bindings.
