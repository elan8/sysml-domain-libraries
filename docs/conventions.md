# Library Conventions

This document standardizes naming and authoring conventions for all SysML libraries in this repository.

## Canonical Roots

- Technical capability libraries belong under `model/technical/`.
- Cross-domain foundation libraries (core structure, units, procurement, physical modeling) belong under `model/generic/`.
- Examples live beside those libraries and are collected by `model/Examples.sysml`. They are not exported from `Elan8`.

## Naming Standards

### Package And File Names

- Place reusable packages below the `Elan8` root namespace.
- Use short `PascalCase` domain nouns for namespace segments, for example `Elan8::Software::Bindings` and `Elan8::Electronics::Actuation`.
- Do not repeat `Elan8`, `Domain`, or the parent domain name in a child package.
- Use `PascalCase` for `.sysml` file basenames.
- Keep folder names lowercase and hyphenated (for example `safety-assurance`, `distributed-systems`).

### Definition Names

- Use singular nouns for definitions (`part def Service`, `item def Event`).
- Do not add a `name` attribute: an element's name is its SysML declared name. An attribute may hold the name of something outside the model (a Modelica class, a broker topic, a container image).
- Do not use SysML reserved words as names (`message`, `event`, `language`, `loop`, `frame`, `derived`, and the rest of SysML v2 8.2.2.1.2).
- Type every numeric attribute with an ISQ quantity (`DurationValue`, `ElectricPotentialValue`, `StorageCapacityValue`, …) or a scalar type; do not declare untyped placeholder `attribute def`s.
- Name kinds of thing, never the role they play in one application (`SwitchSensor`, not `BumperSwitch`).
- Use native SysML for behaviour and interaction (`state`, `action`, `send`, `accept`, `allocate`) instead of library definitions that re-model them.
- Record technology choices as metadata on generic elements (`Elan8::Software::Bindings`), not as technology-specific definitions.

## Example Authoring Checklist

- Provide at least one passing minimal example per family.
- Provide realistic cross-package examples that show how libraries compose.
- Keep examples Spec42-clean unless the example is explicitly documented as parser or semantic-error material.
- State what the example demonstrates in its package `doc` comment.

## Metadata And Quantities

- Metadata values are literals: names, URLs, and codes.
- Quantities, including `unitCost`, live on the part. A quantity literal such as `120 [EUR]` is not a model-level evaluable metadata value.
