# Example Index

Examples are organized under canonical library roots and describe modeling intent for learning and Spec42 validation.

## Domain Examples

None currently. `domain/` was emptied when `domain/robotics` was removed for quality reasons (thin scaffolding, no downstream consumers); technical-library quality is being prioritized before a new domain library is added.

## Electronics Examples

- `technical/electronics/examples/motor-and-power-module/motor-and-power-module.sysml`
  - Purpose: minimal motor/encoder/motor-driver and battery/BMS/regulator composition demonstrating `sum()`-derived mass/power rollups instead of hand-typed totals.
  - Expected outcomes: should validate cross-package reuse of `technical/electronics/actuation` and the `technical/electronics/power` additions (`BatteryPack`, `BatteryManagementSystem`, upgraded `VoltageRegulator`).

## Software Examples

- `technical/software/examples/distributed-orders/distributed-orders.sysml`
  - Purpose: minimal service and deployment architecture.
  - Expected outcomes: should demonstrate service and deployment-node vocabulary composition.
- `technical/software/examples/missing-deployment/missing-deployment.sysml`
  - Purpose: intentionally incomplete deployable model.
  - Expected outcomes: should remain syntactically and semantically valid while illustrating a missing deployment-allocation checklist gap.
- `technical/software/examples/mutating-operation-missing-safety/mutating-operation-missing-safety.sysml`
  - Purpose: intentionally incomplete generic software operation model.
  - Expected outcomes: should remain syntactically and semantically valid while illustrating missing execution-safety policy context.
- `technical/software/examples/capability-missing-realization/capability-missing-realization.sysml`
  - Purpose: intentionally incomplete generic software capability model.
  - Expected outcomes: should remain syntactically and semantically valid while illustrating missing capability-realization traceability.
- `technical/software/examples/tool42/tool42.sysml`
  - Purpose: realistic local software-tool architecture slice using existing software, communication, delivery, observability, and security overlays.
  - Expected outcomes: should satisfy generic implementation-structure, capability-realization, operation-contract, runtime-dependency, release-compatibility, bounded-output, behavior-flow, and mutating-operation safety expectations without adding language-specific reusable vocabulary.
- `technical/software/examples/webshop/webshop.sysml`
  - Purpose: end-to-end webshop architecture, requirements, behavior, and sequence-view example composed from shared software libraries.
  - Expected outcomes: should validate cross-package reuse of distributed service, SQL, Kubernetes, and interaction semantics.
- `technical/software/examples/realtime-task-scheduling/realtime-task-scheduling.sysml`
  - Purpose: minimal realtime task/queue/scheduler composition combined with a `PartProcurement`-annotated compute part, proving the vocabulary extracted from `sysml-robot-vacuum-cleaner` is genuinely product-agnostic.
  - Expected outcomes: should validate cross-package reuse of `technical/software/realtime-runtime` and `generic/procurement`.

## Systems Engineering / Method Examples

Method teaching fixtures live in the optional sibling `mbse-methodology` repository (not required to validate this repo).

## Usage Notes

- Start with the minimal examples to understand library composition.
- Use the intentionally incomplete examples to explain modeling checklist gaps to modelers.
