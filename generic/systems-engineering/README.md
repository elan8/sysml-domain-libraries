# Systems Engineering Technical Libraries

This directory contains cross-domain SysML v2 systems-engineering capabilities that can be reused across business and technical domains.

Use these packages for requirements management, verification planning, traceability, and release or review baselines.

## Best Starting Points

- Start with `requirements/RequirementMetadata.sysml` for requirement role and identity annotations on standard `requirement` usages.
- Use OMG `ModelingMetadata::StatusInfo` (from the SysML standard library) for lifecycle/work status on requirements and other elements.
- Add `requirements/RequirementManagement.sysml` for verification evidence, baselines, and traceability concern vocabulary.
- Add `../units/MonetaryUnits.sysml` when requirements or analyses reference BOM cost or budget limits in a specific currency.
- Add domain-specific libraries from `domain/` and implementation libraries from `technical/` when requirements need to be satisfied by architecture, software, electronics, communication, or robotics elements.
- Use `domain/robotics/examples/inspection-rover/inspection-rover.sysml` as the first cross-domain reference model for requirement-to-verification traceability.

## Structure

- `requirements/RequirementMetadata.sysml` - `@RequirementRole`, `@RequirementIdentity`, and semantic role keywords
- `requirements/RequirementManagement.sysml` - verification evidence, baselines, traceability concerns (no custom requirement defs)
- `../units/MonetaryUnits.sysml` - currency units and `MonetaryAmount` for cost and BOM attributes

## Package Guidance

### requirements

- **When to use:** stakeholder-to-system requirement breakdown, status-controlled requirements, verification planning, evidence tracking, and traceability gap analysis.
- **Anti-patterns:** requirements with implicit lifecycle state, stakeholder needs not derived into system requirements, system requirements without satisfaction or verification coverage.
- **Minimum checklist:** requirements declare `@StatusInfo`, user needs derive system requirements via `#derivation`, system requirements are satisfied by model elements, and active system requirements are verified by a case or evidence artifact.

## Modeling Checklist

- Create stakeholder-facing needs as `requirement` usages with `@RequirementRole { role = user; }` and `@StatusInfo`.
- Derive system requirements as plain `requirement` usages with appropriate `@RequirementRole` (e.g. `functional`, `performance`, `safety`).
- Use `#derivation connection` to link stakeholder needs to derived system requirements.
- Use `satisfy` to connect requirements to architecture, technical, or domain elements.
- Use `verification` cases with `objective { verify ... }` for every active system or safety requirement.
- Use evidence and baselines when the model needs review, release, or audit readiness.

## Quality

- Validate SysML syntax and semantic consistency with `scripts/validate-spec42.ps1`.
- Use the modeling checklist above for completeness until executable requirements-management checks are available.
- Do not add non-executable YAML rule catalogs; encode enforceable checks in Spec42 or another real validator first.
