# Electronics Technical Libraries

This directory contains technical electronics capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs electronics vocabulary for power, compute, I/O, board integration, and bus-level interfaces while keeping business-domain semantics outside the electronics layer.

## Best Starting Points

- Start with `core/` for common electronics concepts.
- Add `power/` for power sources, loads, conversion, and distribution.
- Add `compute/`, `io/`, `buses/`, `interconnection/`, `board/`, and `assembly/` as the model moves from logical electronics into implementation structure.
- Add `components/` for standard board-level passives, semiconductors, and integrated circuits.
- Add `wireless/` for physical wireless modules that realize communication-level wireless channels.
- Add `actuation/` for electric motors, solenoids, steppers, servos, and actuator drivers.
- Add `sensing/` for inertial measurement, bumper/lift hazard switches, and other electromechanical sensing components.

## Structure

- `core/` - base electronics concepts (`Elan8::Electronics::Core`), including shared `mass`/`powerDraw` on `ElectronicsComponent` for budget rollups.
- `power/` - electrical power and conversion overlays (`Elan8::Electronics::Power`), including `BatteryPack` and `BatteryManagementSystem`.
- `compute/` - embedded compute and firmware overlays (`Elan8::Electronics::Compute`).
- `io/` - digital/analog I/O and interface overlays (`Elan8::Electronics::Io`).
- `buses/` - board-level bus and link overlays (`Elan8::Electronics::Buses`).
- `interconnection/` - SysML v2 physical port and interface definitions for buses, GPIO, PWM, and power rails (`Elan8::Electronics::Interconnection`).
- `components/` - standard board-level electronic components such as resistors, capacitors, inductors, diodes, transistors, fuses, crystals, and integrated circuits (`Elan8::Electronics::Components`).
- `board/` - bare printed-board technology and physical properties (`Elan8::Electronics::Board`).
- `assembly/` - PCBA, electronics-module, and box-build composition (`Elan8::Electronics::Assembly`).
- `actuation/` - electric motor, solenoid, stepper, servo, and actuator-driver vocabulary (`Elan8::Electronics::Actuation`).
- `sensing/` - typed measurement items, generic protocol-specializable sensor data ports, explicit passive/powered sensor classes, switches, and encoders (`Elan8::Electronics::Sensing`).
- `wireless/` - physical wireless modules (`Elan8::Electronics::Wireless`) linked to `Elan8::Communication::Wireless` channels.

## Related Layers

- Communication protocol libraries reside in `../communication/`.
- Electrical actuators import `../mechanical/interconnection/` for rotational and translational output boundaries.
- Requirements method libraries (roles, evidence patterns) are optional and live in sibling `mbse-methodology` — not a dependency of electronics vocabulary.
- Business-domain libraries, such as robotics, should compose electronics concepts for compute, power, I/O, and board-level implementation detail.

## Modeling Checklist

- Use `core/` for shared electronics components and electrical interfaces.
- Use `power/` to make power rails, load groups, conversion, voltage, and current budgets explicit.
- Use `compute/` to connect embedded compute units to firmware, memory, peripherals, and power rails.
- Use `buses/` and `io/` when sensor, actuator, or board interfaces need implementation-level traceability.
- Use `interconnection/` for typed electrical `port def` boundaries and `interface def` links between electronics components. I2C uses controller/target roles, SPI uses controller/peripheral roles, and UART uses conjugated peer ports.
- Use `components/` for BOM-level component types. Electrical characteristics such as resistance, capacitance, and forward voltage are attributes; physical pins and terminals are ports.
- Use `board/` for an unpopulated PCB and `assembly/` for a PCBA containing that board plus mounted physical components.
- Use `actuation/` and `sensing/` for actuators and sensors. Measurement items describe what a sensor measures; data, signal, and power ports describe its external interfaces.
- Prefer `sum()`-derived `mass`/`powerDraw` at assembly level over hand-typed totals — every `ElectronicsComponent` already carries both attributes, so assemblies can roll them up from their actual children instead of asserting an independent number (see `examples/motor-and-power-module/`).

## Notes

- Electronics libraries are technical and business-agnostic.
- Foundational types live in `Elan8::Electronics::Core`; other packages specialize those concepts.
- Protocol-specific electrical ports belong to electronics; logical channels, sessions, operations, and bindings belong to communication. `Elan8::Electronics::Buses` composes both viewpoints.
- Business domains (for example robotics) can compose these electronics libraries without importing business semantics back into technical layers.
- `ElectronicsComponent.mass`/`powerDraw` carry no default value and are not mandatory to set — a pure power *source* like `BatteryPack` legitimately leaves `powerDraw` unset.
