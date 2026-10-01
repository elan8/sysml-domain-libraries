# Mechanical Technical Libraries

This directory contains technical mechanical capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs vocabulary for purely mechanical components — parts with mass but no electrical characteristics — while keeping business-domain semantics outside the mechanical layer.

## Best Starting Points

- Start with `Mechanical.sysml` (`Elan8::Mechanical`). Nested `Core` is the shared `MechanicalComponent` base, and nested `Interconnection` is the rotational and translational ports and links.
- Add `drivetrain/` for gearbox, wheel, and caster-wheel vocabulary.

## Structure

- `Mechanical.sysml` - `Elan8::Mechanical`, including nested `Core` (`Elan8::Mechanical::Core`, `mass` on `MechanicalComponent`) and `Interconnection` (`Elan8::Mechanical::Interconnection`).
- `drivetrain/` - gearbox, wheel, and caster-wheel vocabulary (`Elan8::Mechanical::Drivetrain`).

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
- `MechanicalComponent` deliberately does **not** share a common ancestor with `ElectronicsComponent` (no multi-specialization) — `mass` is independently declared on both. A purely mechanical part specializes `MechanicalComponent`; an electromechanical part (has a port) specializes `ElectronicsComponent` instead, even though it also has mass.
- `MechanicalComponent` carries no `powerDraw` — purely mechanical parts don't draw power. If a part needs both `mass` and `powerDraw`, it isn't purely mechanical and belongs in `../electronics/` instead.
