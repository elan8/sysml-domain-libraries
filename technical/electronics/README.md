# Electronics Technical Libraries

This directory contains technical electronics capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs electronics vocabulary for power, compute, I/O, board integration, and bus-level interfaces while keeping business-domain semantics outside the electronics layer.

## Best Starting Points

- Start with `electronics-core/` for common electronics concepts.
- Add `power/` for power sources, loads, conversion, and distribution.
- Add `compute/`, `io/`, `buses/`, `interconnection/`, and `board/` as the model moves from logical electronics into implementation structure.
- Add `actuation/` for motors, encoders, and motor drivers.
- Add `sensing/` for inertial measurement and other electromechanical sensing components.

## Structure

- `electronics-core/` - base electronics concepts (`ElectronicsCore`), including shared `mass`/`powerDraw` on `ElectronicsComponent` for budget rollups.
- `power/` - electrical power and conversion overlays (`ElectricalPowerDomain`), including `BatteryPack` and `BatteryManagementSystem`.
- `compute/` - embedded compute and firmware overlays (`EmbeddedComputeDomain`).
- `io/` - digital/analog I/O and interface overlays (`ElectronicIoDomain`).
- `buses/` - board-level bus and link overlays (`ElectronicBusDomain`).
- `interconnection/` - SysML v2 physical port and interface definitions for buses, GPIO, PWM, and power rails (`ElectronicsInterconnection`).
- `board/` - board assembly and integration overlays (`BoardIntegrationDomain`).
- `actuation/` - motor, encoder, and motor-driver vocabulary (`ElectronicActuationDomain`).
- `sensing/` - inertial and other electromechanical sensing vocabulary (`SensingDomain`).

## Related Layers

- Communication protocol libraries reside in `../communication/`.
- Requirements method libraries (roles, evidence patterns) are optional and live in sibling `mbse-methodology` — not a dependency of electronics vocabulary.
- Business-domain libraries, such as robotics, should compose electronics concepts for compute, power, I/O, and board-level implementation detail.

## Modeling Checklist

- Use `electronics-core/` for shared electronics components and electrical interfaces.
- Use `power/` to make power rails, load groups, conversion, voltage, and current budgets explicit.
- Use `compute/` to connect embedded compute units to firmware, memory, peripherals, and power rails.
- Use `buses/` and `io/` when sensor, actuator, or board interfaces need implementation-level traceability.
- Use `interconnection/` for typed `port def` and `interface def` wiring between electronics components.
- Use `actuation/` and `sensing/` for motor, encoder, motor-driver, and IMU vocabulary.
- Prefer `sum()`-derived `mass`/`powerDraw` at assembly level over hand-typed totals — every `ElectronicsComponent` already carries both attributes, so assemblies can roll them up from their actual children instead of asserting an independent number (see `examples/motor-and-power-module/`).

## Notes

- Electronics libraries are technical and business-agnostic.
- Foundational types live in `ElectronicsCore`; other packages specialize those concepts.
- Business domains (for example robotics) can compose these electronics libraries without importing business semantics back into technical layers.
- `ElectronicsComponent.mass`/`powerDraw` carry no default value and are not mandatory to set — a pure power *source* like `BatteryPack` legitimately leaves `powerDraw` unset.
