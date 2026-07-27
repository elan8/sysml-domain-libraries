# Units

Cross-domain unit and quantity helpers that complement the OMG ISQ/SI standard library.

## Contents

| Package | File | Purpose |
| --- | --- | --- |
| `MonetaryUnits` | `MonetaryUnits.sysml` | Currency-typed monetary amounts (EUR, USD, …) |
| `EngineeringUnits` | `EngineeringUnits.sysml` | `Ah` / `mAh` charge and `ms` duration literals |

## MonetaryUnits

```sysml
private import MonetaryUnits::*;

attribute bomCost : MonetaryAmount = 120 [EUR];
```

BOM roll-ups assume **one currency per sum** (no exchange rates).

## EngineeringUnits

```sysml
private import EngineeringUnits::*;
private import ISQ::*;

attribute capacity : ElectricChargeValue = 12500 [mAh];
attribute latency : DurationValue = 100 [ms];
```

Use these when models need milliampere-hour or millisecond literals that are not declared in the bundled OMG quantities library.
