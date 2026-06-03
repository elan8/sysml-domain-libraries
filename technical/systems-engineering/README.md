# Systems Engineering Technical Libraries

This directory contains cross-domain SysML v2 systems-engineering capabilities that can be reused across business and technical domains.

Use these packages for requirements management, verification planning, traceability, and release or review baselines.

## Best Starting Points

- Start with `requirements/RequirementManagement.sysml` for managed requirements, requirement status, requirement classes, verification cases, and traceability vocabulary.
- Add domain-specific libraries from `domain/` and implementation libraries from `technical/` when requirements need to be satisfied by architecture, software, electronics, communication, or robotics elements.
- Use `domain/robotics/examples/inspection-rover/inspection-rover.sysml` as the first cross-domain reference model for requirement-to-verification traceability.

## Structure

- `requirements/RequirementManagement.sysml` - shared requirement, verification, evidence, baseline, and traceability vocabulary
- `requirements/rules/requirement-management-rules.yaml` - requirement management rule catalog

## Package Guidance

### requirements

- **When to use:** stakeholder-to-system requirement breakdown, status-controlled requirements, verification planning, evidence tracking, and traceability gap analysis.
- **Anti-patterns:** requirements with implicit lifecycle state, stakeholder needs not derived into system requirements, system requirements without satisfaction or verification coverage.
- **Minimum checklist:** managed requirements declare status, stakeholder/user requirements derive system requirements, system requirements are satisfied by model elements, and active system requirements are verified by a case or evidence artifact.

## Modeling Checklist

- Create stakeholder-facing needs as `UserRequirement` or `StakeholderRequirement`.
- Derive active `SystemRequirement` specializations from stakeholder needs.
- Use `satisfy` to connect requirements to architecture, technical, or domain elements.
- Use `verification` cases with `objective { verify ... }` for every active system or safety requirement.
- Use evidence and baselines when the model needs review, release, or audit readiness.

## Rules And Quality

- Rule catalogs live beside each package in `rules/`.
- Severity interpretation and naming standards are defined in `docs/conventions.md`.
- Start with warning-level hygiene, then promote coverage and lifecycle checks to error-level gates for production release baselines.
