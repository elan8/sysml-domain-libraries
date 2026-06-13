# Electronics Technical Libraries

This directory contains technical electronics capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs electronics vocabulary for power, compute, I/O, board integration, and bus-level interfaces while keeping business-domain semantics outside the electronics layer.

## Best Starting Points

- Start with `electronics-core/` for common electronics concepts.
- Add `power/` for power sources, loads, conversion, and distribution.
- Add `compute/`, `io/`, `buses/`, `interconnection/`, and `board/` as the model moves from logical electronics into implementation structure.

## Structure

- `electronics-core/` - base electronics concepts (`ElectronicsCore`).
- `power/` - electrical power and conversion overlays (`ElectricalPowerDomain`).
- `compute/` - embedded compute and firmware overlays (`EmbeddedComputeDomain`).
- `io/` - digital/analog I/O and interface overlays (`ElectronicIoDomain`).
- `buses/` - board-level bus and link overlays (`ElectronicBusDomain`).
- `interconnection/` - SysML v2 physical port and interface definitions for buses, GPIO, PWM, and power rails (`ElectronicsInterconnection`).
- `board/` - board assembly and integration overlays (`BoardIntegrationDomain`).

## Related Layers

- Communication protocol libraries reside in `../communication/`.
- Requirements and verification libraries reside in `../../generic/systems-engineering/`.
- Business-domain libraries, such as robotics, should compose electronics concepts for compute, power, I/O, and board-level implementation detail.

## Modeling Checklist

- Use `electronics-core/` for shared electronics components and electrical interfaces.
- Use `power/` to make power rails, load groups, conversion, voltage, and current budgets explicit.
- Use `compute/` to connect embedded compute units to firmware, memory, peripherals, and power rails.
- Use `buses/` and `io/` when sensor, actuator, or board interfaces need implementation-level traceability.
- Use `interconnection/` for typed `port def` and `interface def` wiring between electronics components.

## Notes

- Electronics libraries are technical and business-agnostic.
- Foundational types live in `ElectronicsCore`; other packages specialize those concepts.
- Business domains (for example robotics) can compose these electronics libraries without importing business semantics back into technical layers.
