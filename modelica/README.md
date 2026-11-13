# Modelica behaviour of the domain libraries

A part definition gets its physics from a Modelica class, named with
`@Elan8::PhysicalModeling::ModelicaModel` (see
[`PhysicalModeling`](../model/generic/physical-modeling/README.md)). Most parts bind to the
Modelica Standard Library (MSL) 4.1.0; this directory holds the `Elan8` Modelica package
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

Specializations use their supertype's binding: a `TantalumCapacitor` is a
`Modelica.Electrical.Analog.Basic.Capacitor`. Parts without a binding, such as `Diode`
(whose ratings are not the MSL diode's parameters), are not simulated.

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
