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
- `technical/software/examples/tool42/tool42.sysml`
  - Purpose: realistic open-source tool modeling slice using distributed-systems, delivery-ops, observability, and security overlays.
  - Expected outcomes: should satisfy basic service/release/observability/security vocabulary coverage and expose where relation semantics need extension.

## Usage Notes

- Start with the minimal examples to understand library composition.
- Use the intentionally failing examples to validate rule evaluation and explain diagnostics to modelers.
