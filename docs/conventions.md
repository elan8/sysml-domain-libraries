# Library Conventions

This document standardizes naming and authoring conventions for all SysML libraries in this repository.

## Canonical Roots

- Business-domain libraries belong under `domain/`.
- Technical capability libraries belong under `technical/`.
- Cross-domain systems-engineering capabilities belong under `technical/systems-engineering/`.
- New files should not be added under deprecated legacy roots.

## Naming Standards

### Package And File Names

- Use `PascalCase` for SysML package names and `.sysml` file basenames (for example `RobotControl`, `DistributedSystems`).
- Keep folder names lowercase and hyphenated (for example `safety-assurance`, `distributed-systems`).

### Definition Names

- Use singular nouns for definitions (`part def Service`, `item def Event`).
- Prefer a common base `name` attribute when specializing existing base definitions.
- Use specialized attribute names (for example `serviceName`, `nodeName`) only when domain clarity is improved and there is no ambiguity.

## Example Authoring Checklist

- Provide at least one passing minimal example per family.
- Provide realistic cross-package examples that show how libraries compose.
- Keep examples Spec42-clean unless the example is explicitly documented as parser or semantic-error material.
- Document intended learning outcomes in `examples/README.md`.
