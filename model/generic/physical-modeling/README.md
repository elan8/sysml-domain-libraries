# Physical Modeling

Links a part definition to an external dynamic model — a Modelica class or an
FMI Functional Mock-up Unit — and defines a simulation run as an analysis case.
The SysML model keeps system identity, structure, and the scenario. It does not
encode constitutive equations.

## Contents

| Package | File | Purpose |
| --- | --- | --- |
| `Elan8::PhysicalModeling` | `PhysicalModeling.sysml` | `ModelicaModel` and `FmuModel` metadata; `SimulationScenario` analysis case |

## Usage

Tag the part definition with the artifact a simulation tool should execute:

```sysml
private import Elan8::PhysicalModeling::*;

part def MassSpring {
    @ModelicaModel {
        resourceUri = "models/MassSpring.mo";
        className = "Example.MassSpring";
    }
}

part def Damper {
    @FmuModel {
        resourceUri = "models/Damper.fmu";
        fmuKind = FmuKind::coSimulation;
        modelIdentifier = "Damper";
        fmiVersion = "3.0";
    }
}
```

A binding names the class and pairs SysML names with Modelica names where they
differ. Without `resourceUri`, the class is in the Modelica Standard Library or in
this repository's `Elan8` Modelica package ([`modelica/`](../../../modelica/README.md));
with it, in a file relative to the SysML file:

```sysml
part def Resistor :> TwoTerminalPassiveComponent {
    @ModelicaModel {
        className = "Modelica.Electrical.Analog.Basic.Resistor";
        parameters = ("resistance=R");
        pins = ("terminal1=p", "terminal2=n");
    }
    attribute resistance : ResistanceValue;
}
```

A parameter receives its attribute's value in SI units. Unpaired Modelica
parameters keep their defaults; every parameter without a default and every pin
must be paired, by an entry or by the same name. A part definition without its
own binding uses its nearest bound supertype's. `scripts/check_modelica_bindings.py`
checks all of this.

Specialize `SimulationScenario` for one run. `in` parameters are inputs, `out`
parameters are the signals to trace, and `@ExternalVariable` maps a feature to
the Modelica or FMU variable name when the names differ. A co-simulation FMU
sets `communicationStep` and can leave `solver` unset.

```sysml
analysis def MassSpringStep :> SimulationScenario {
    subject massSpring : MassSpring :>> simulatedSystem;
    attribute :>> stopTime = 5 [s];
    attribute :>> outputInterval = 0.01 [s];
    attribute :>> solver {
        :>> name = "dassl";
        :>> relativeTolerance = 0.000001;
    }
    in mass : MassValue = 1 [kg];
    out position : LengthValue {
        @ExternalVariable { variableName = "s"; }
    }
}
```

`@TimeSeriesInput` on an `in` parameter points at a file when the input is a
signal rather than a constant. See `examples/mass-spring/`.
