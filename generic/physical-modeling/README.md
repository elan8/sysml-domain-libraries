# Physical Modeling

Domain-agnostic primitives for writing constitutive (behavior) equations on physical
components, so a future simulation compiler can assemble a DAE/ODE from connected
components instead of each domain library reinventing a differentiation primitive.

## Contents

| Package | File | Purpose |
| --- | --- | --- |
| `Elan8::PhysicalModeling` | `PhysicalModeling.sysml` | `der` differentiation primitive; `AcrossVariable`/`ThroughVariable` metadata defs for tagging potential-like vs flow-like port attributes |

## Usage

Tag the across/through attributes on the port definition:

```sysml
private import Elan8::PhysicalModeling::*;

port def ElectricalTerminalPort {
    attribute potential : ElectricPotentialValue {
        @AcrossVariable;
    }
    attribute current : ElectricCurrentValue {
        @ThroughVariable;
    }
}
```

Write component behavior as acausal `constraint` bodies, using `==` (the equality
operator — `=` is a feature-value binding and is a constraint-body syntax error):

```sysml
constraint capacitorLaw {
    terminal1.current == capacitance * der(terminal1.potential - terminal2.potential);
}
```

`der` has no evaluatable body — it is a signature a simulation compiler recognizes by
its `@DerivativePrimitive` metadata and replaces with a state derivative during DAE
assembly. `@AcrossVariable`/`@ThroughVariable` label which port attributes are
potential-like versus flow-like. They do not by themselves make a plain
`connect`/`interface` equalize across variables or sum through variables to zero at a
shared node — deriving KVL/KCL-style conservation constraints from connection topology
is the simulation compiler's job, not this library's — see the doc comment in
`PhysicalModeling.sysml` for why plain `connect` binding cannot do this generically.
