# Mechanical Technical Libraries

This directory contains technical mechanical capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs vocabulary for purely mechanical components — parts with mass but no electrical characteristics — while keeping business-domain semantics outside the mechanical layer.

## Best Starting Points

- Start with `Mechanical.sysml` (`Elan8::Mechanical`). Nested `Core` is the shared `MechanicalComponent` base, and nested `Interconnection` is the rotational and translational ports and links.
- Add `drivetrain/` for gearbox, wheel, and caster-wheel vocabulary.
- Add `translational/` for a mass, spring, damper and fixed support that simulate through the Modelica Standard Library.
- Add `rotational/` for an inertia, torsional spring and damper, fixed support and torque source; `drivetrain/` then also has a simulating `Gearbox` and `RollingWheel`.

## Structure

- `Mechanical.sysml` - `Elan8::Mechanical`, including nested `Core` (`Elan8::Mechanical::Core`, `MechanicalComponent` specializes `PhysicalComponent` and inherits `mass`) and `Interconnection` (`Elan8::Mechanical::Interconnection`).
- `drivetrain/` - gearbox, wheel, and caster-wheel vocabulary (`Elan8::Mechanical::Drivetrain`).
- `translational/` - one-dimensional mass, spring, damper and fixed support (`Elan8::Mechanical::Translational`), bound to Modelica classes; see `examples/mass-spring-damper/`.
- `rotational/` - inertia, torsional spring and damper, fixed support and torque source (`Elan8::Mechanical::Rotational`), bound to Modelica classes; see `examples/drive-wheel/` for a motor, gearbox, wheel and body.
- [DC motor drive](examples/dc-motor-drive/README.md) - simulate a motor under viscous load, measure current and shaft speed, and verify a speed requirement with Run42.
- [Force-driven mass](examples/force-driven-mass/README.md) - simulate a mass under constant and step forces and compare the measured position with an analytical response.

## Related Layers

- Electromechanical actuators remain `ElectronicsComponent`-based in `../electronics/`, but import this family's mechanical interconnection vocabulary for their physical outputs.
- Business-domain libraries should compose mechanical concepts for structural and drivetrain implementation detail, the same way they already compose `../electronics/`.

## Modeling Checklist

- Use nested `Core` in `Mechanical.sysml` for any purely mechanical part that needs to participate in a `sum()`-derived mass rollup.
- Use nested `Interconnection` for torque/rotation and force/translation boundaries between actuators, transmissions, and loads.
- Use `drivetrain/` when a model needs gear reduction, wheel geometry, or an unpowered caster wheel.
- Prefer `sum()`-derived `mass` at assembly level over hand-typed totals, exactly as `../electronics/` already does for `ElectronicsComponent` (see `examples/mechanical-composition/`).

## Notes

- Mechanical libraries are technical and business-agnostic.
- `MechanicalComponent` and `ElectronicsComponent` both specialize `Elan8::Core::PhysicalComponent`, where `mass` is declared once. A purely mechanical part specializes `MechanicalComponent`. An electromechanical part specializes `ElectronicsComponent`.
- `powerDraw` is declared on `ElectronicsComponent`, not on `MechanicalComponent`. A part that draws electrical power belongs in `../electronics/`.
