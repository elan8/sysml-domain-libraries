# Monetary Units

Cross-domain currency vocabulary for BOM, cost, and budget modeling.

## Contents

- **`MonetaryUnits`** — `MonetaryAmount` scalar type and currency unit attributes (EUR, USD, GBP, JPY, CHF, CNY)

## Usage

```sysml
private import MonetaryUnits::*;

attribute bomCost : MonetaryAmount = 120 [EUR];
```

BOM roll-ups and analysis constraints assume **one currency per sum** (no exchange rates).

Pair with `technical/systems-engineering/requirements/RequirementManagement.sysml` when cost limits are expressed as managed system requirements.
