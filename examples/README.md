# Example Index

Examples are organized under canonical library roots and include expected rule outcomes for learning and CI validation.

## Robotics Examples

- `domain/robotics/examples/minimal-robot/minimal-robot.sysml`
  - Purpose: smallest useful robotics baseline built from core and structure overlays.
  - Expected outcomes: should satisfy baseline modeling intent from `robotics-core` and structure overlays.
- `domain/robotics/examples/control-missing-feedback/control-missing-feedback.sysml`
  - Purpose: intentionally incomplete control model.
  - Expected outcomes: expected to trigger `CTRL002` from `domain/robotics/control/rules/robot-control-rules.yaml`.

## Software Examples

- `technical/software/examples/distributed-orders/distributed-orders.sysml`
  - Purpose: minimal service and deployment architecture.
  - Expected outcomes: should satisfy allocation and interface expectations in `distributed-systems` rule catalog.
- `technical/software/examples/missing-deployment/missing-deployment.sysml`
  - Purpose: intentionally incomplete deployable model.
  - Expected outcomes: expected to trigger `DS301` from `technical/software/distributed-systems/rules/distributed-systems-rules.yaml`.
- `technical/software/examples/mutating-operation-missing-safety/mutating-operation-missing-safety.sysml`
  - Purpose: intentionally incomplete generic software operation model.
  - Expected outcomes: expected to trigger `SWC301` from `technical/software/delivery-ops/rules/software-control-plane-rules.yaml`.
- `technical/software/examples/capability-missing-realization/capability-missing-realization.sysml`
  - Purpose: intentionally incomplete generic software capability model.
  - Expected outcomes: expected to trigger `SWCORE101` from `technical/software/software-core/rules/software-core-rules.yaml`.
- `technical/software/examples/tool42/tool42.sysml`
  - Purpose: realistic local software-tool architecture slice using existing software, communication, delivery, observability, and security overlays.
  - Expected outcomes: should satisfy generic implementation-structure, capability-realization, operation-contract, runtime-dependency, release-compatibility, bounded-output, behavior-flow, and mutating-operation safety expectations without adding language-specific reusable vocabulary.
- `technical/software/examples/webshop/webshop.sysml`
  - Purpose: end-to-end webshop architecture, requirements, behavior, and sequence-view example composed from shared software libraries.
  - Expected outcomes: should validate cross-package reuse of distributed service, SQL, Kubernetes, and interaction semantics.

## Usage Notes

- Start with the minimal examples to understand library composition.
- Use the intentionally failing examples to validate rule evaluation and explain diagnostics to modelers.
