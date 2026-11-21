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
| `Components::CurrentSource` | `Modelica.Electrical.Analog.Sources.ConstantCurrent` |
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
| `Drivetrain::Gearbox` | `Modelica.Mechanics.Rotational.Components.IdealGear` |
| `Drivetrain::RollingWheel` | `Modelica.Mechanics.Rotational.Components.IdealRollingWheel` |
| `Actuation::BrushedDcMotor` | `Elan8.Electronics.Actuation.BrushedDcMotor` (this directory) |

Specializations use their supertype's binding: a `TantalumCapacitor` is a
`Modelica.Electrical.Analog.Basic.Capacitor`. Parts without a binding, such as `Diode`
(whose ratings are not the MSL diode's parameters), are not simulated.

`BrushedDcMotor` has its own class because the MSL's DC machine is a loss and thermal model whose
parameters are a datasheet's nominal point, not the plain resistance, inductance, torque constant
and rotor inertia that sizing a drive starts from. The class composes MSL elements: a `Resistor`, an
`Inductor`, a `RotationalEMF` and an `Inertia`. It is also the torque-level equivalent of a brushless
or permanent-magnet synchronous motor under ideal commutation or field-oriented control; a model of
the three phases themselves is not in the libraries yet.

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
