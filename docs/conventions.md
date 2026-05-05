# Library Conventions

This document standardizes naming and rule semantics for all SysML libraries in this repository.

## Canonical Roots

- Business-domain libraries belong under `domain/`.
- Technical capability libraries belong under `technical/`.
- New files should not be added under deprecated legacy roots.

## Naming Standards

### Package And File Names

- Use `PascalCase` for SysML package names and `.sysml` file basenames (for example `RobotControl`, `DistributedSystems`).
- Keep folder names lowercase and hyphenated (for example `safety-assurance`, `distributed-systems`).
- Name rule files as lowercase hyphenated `<library>-rules.yaml`.

### Definition Names

- Use singular nouns for definitions (`part def Service`, `item def Event`).
- Prefer a common base `name` attribute when specializing existing base definitions.
- Use specialized attribute names (for example `serviceName`, `nodeName`) only when domain clarity is improved and there is no ambiguity.

### Rule IDs

- Preserve established library prefixes (for example `CTRL`, `DS`) to avoid breaking existing references.
- For new catalogs, choose one stable uppercase prefix per library family and reuse it consistently.
- Use a three-digit numeric suffix (`CTRL001`, `DS201`).
- Keep IDs stable after publication.

## Rule Severity Semantics

Severity must express enforcement intent, not author preference.

- `warning`: modeling hygiene and recommendation-level guidance.
- `error`: release-gating violations that should fail CI.

Recommended maturity profile:

- **Starter profile:** enforce only syntax and structural safety as `error`; keep completeness checks as `warning`.
- **Production profile:** promote contractual, allocation, and safety-critical checks to `error`.

## Rule Authoring Checklist

- Every rule has a clear title and actionable description.
- Rule category reflects what modelers should inspect.
- Description states what to fix, not only what failed.
- Severity aligns with the profile guidance above.

## Example Authoring Checklist

- Provide at least one passing minimal example per family.
- Provide at least one intentionally failing example per family.
- Document expected rule outcomes by ID in `examples/README.md`.
