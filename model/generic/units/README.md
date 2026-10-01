# Units

Cross-domain unit and quantity helpers that complement the OMG ISQ/SI standard library.

## Contents

| Package | File | Purpose |
| --- | --- | --- |
| `Elan8::Units::Money` | `MonetaryUnits.sysml` | Currency-typed monetary amounts (EUR, USD, …) with typographic symbols |
| `Elan8::Units::Engineering` | `EngineeringUnits.sysml` | `Ah` / `mAh` charge and `ms` duration literals |

## Elan8::Units::Money

```sysml
private import Elan8::Units::Money::*;

attribute bomCost : MonetaryAmount = 120 [EUR];
```

The short name is the ISO 4217 code used in the literal (`EUR`). `symbol` is the typographic sign (`€` for `'euro'`) and `decimalPlaces` is the minor-unit exponent (`2` for euro, `0` for yen).

BOM roll-ups assume **one currency per sum** (no exchange rates).

## Elan8::Units::Engineering

```sysml
private import Elan8::Units::Engineering::*;
private import ISQ::*;

attribute capacity : ElectricChargeValue = 12500 [mAh];
attribute latency : DurationValue = 100 [ms];
```

Use these when models need milliampere-hour or millisecond literals that are not declared in the bundled OMG quantities library.
