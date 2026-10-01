# Library Conventions

This document standardizes naming and authoring conventions for all SysML libraries in this repository.

## Canonical Roots

- Technical capability libraries belong under `model/technical/`.
- Cross-domain foundation libraries (core structure, units, procurement, physical modeling) belong under `model/generic/`.
- Examples live beside those libraries and are collected by `model/Examples.sysml`. They are not exported from `Elan8`.

## Naming Standards

### Package And File Names

- Place reusable packages below the `Elan8` root namespace.
- Use short `PascalCase` domain nouns for namespace segments, for example `Elan8::Software::Distributed` and `Elan8::Electronics::Actuation`.
- Do not repeat `Elan8`, `Domain`, or the parent domain name in a child package.
- Use `PascalCase` for `.sysml` file basenames.
- Keep folder names lowercase and hyphenated (for example `safety-assurance`, `distributed-systems`).

### Definition Names

- Use singular nouns for definitions (`part def Service`, `item def Event`).
- Prefer a common base `name` attribute when specializing existing base definitions.
- Use specialized attribute names (for example `serviceName`, `nodeName`) only when domain clarity is improved and there is no ambiguity.

## Example Authoring Checklist

- Provide at least one passing minimal example per family.
- Provide realistic cross-package examples that show how libraries compose.
- Keep examples Spec42-clean unless the example is explicitly documented as parser or semantic-error material.
- State what the example demonstrates in its package `doc` comment.

## Metadata And Quantities

- Metadata values are literals: names, URLs, and codes.
- Quantities, including `unitCost`, live on the part. A quantity literal such as `120 [EUR]` is not a model-level evaluable metadata value.
