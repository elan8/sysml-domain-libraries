# Procurement

Cross-domain part procurement and traceability metadata, extracted from the
`sysml-robot-vacuum-cleaner` showcase (`model/90_library/PurchasedParts.sysml`),
where it was already designed to be reusable ("imports only reusable domain
and standard libraries so it can later move to a separate repository
unchanged").

## Contents

| Package | File | Purpose |
| --- | --- | --- |
| `Elan8::Procurement` | `PartProcurement.sysml` | `CostedPart` unit-cost mixin, `BuyPart` and `MakePart` metadata, plus `PartLifecycleStatus` |

## Elan8::Procurement

```sysml
private import Elan8::Procurement::*;
private import Elan8::Units::Money::*;

part def MyMcu :> SomeBaseDefinition, CostedPart {
    @BuyPart {
        manufacturer = "Example Semiconductor Co.";
        manufacturerPartNumber = "ES-MCU-100";
        url = "https://example.invalid/es-mcu-100";
    }
    attribute :>> unitCost = 120 [EUR];
}

part def MyBracket :> SomeBaseDefinition, CostedPart {
    @MakePart;
    attribute :>> unitCost = 45 [EUR];
}
```

`CostedPart.unitCost` is a `MonetaryAmount`. Set it on the part (`120 [EUR]`);
the symbol and minor-unit exponent come from that `MonetaryUnit`. `@BuyPart`
and `@MakePart` carry only literals: manufacturer, manufacturer part number,
and a product URL for a catalog part. A make part's unit cost is a
manufacturing estimate, not a catalog price. Internal model identity stays
semantic. This deliberately carries no domain- or technology-specific
semantics, so any project-local catalogue can specialize `CostedPart` and
annotate its own part definitions instead of re-deriving the same pattern
locally.
