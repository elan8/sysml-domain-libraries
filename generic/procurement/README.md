# Procurement

Cross-domain part procurement and traceability metadata, extracted from the
`sysml-robot-vacuum-cleaner` showcase (`model/90_library/PurchasedParts.sysml`),
where it was already designed to be reusable ("imports only reusable domain
and standard libraries so it can later move to a separate repository
unchanged").

## Contents

| Package | File | Purpose |
| --- | --- | --- |
| `Elan8::Procurement` | `PartProcurement.sysml` | `BuyPart` metadata and `PartLifecycleStatus` for any purchasable part definition |

## Elan8::Procurement

```sysml
private import Elan8::Procurement::*;

part def MyMcu :> SomeBaseDefinition {
    @BuyPart {
        manufacturer = "Example Semiconductor Co.";
        manufacturerPartNumber = "ES-MCU-100";
        productPageUrl = "https://example.invalid/es-mcu-100";
        datasheetUrl = "https://example.invalid/es-mcu-100/datasheet";
        datasheetDocumentId = "DS-0001";
        datasheetRevision = "Rev 1";
        lifecycleStatus = PartLifecycleStatus::active;
        sourceCheckedOn = "2026-07-28";
    }
}
```

`BuyPart` annotates any `SysML::PartDefinition` with manufacturer, external
documentation links, and lifecycle status. Internal model identity stays
semantic; only human-facing external identifiers (part numbers, datasheet
revisions) are plain text. This deliberately carries no domain- or
technology-specific semantics, so any project-local or vendor-specific
catalogue (electronics, mechanical, or otherwise) can annotate its own part
definitions with it instead of re-deriving the same pattern locally.
