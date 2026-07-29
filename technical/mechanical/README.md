# Mechanical Technical Libraries

This directory contains technical mechanical capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs vocabulary for purely mechanical components — parts with mass but no electrical characteristics — while keeping business-domain semantics outside the mechanical layer.

## Best Starting Points

- Start with `core/` for the shared `MechanicalComponent` base.
- Add `interconnection/` for rotational and translational mechanical ports and links.
- Add `drivetrain/` for gearbox, wheel, and caster-wheel vocabulary.

## Structure

- `core/` - base mechanical concept (`MechanicalCore`), providing `mass` on `MechanicalComponent` for budget rollups.
- `interconnection/` - non-causal rotational and translational mechanical boundaries (`MechanicalInterconnection`).
- `drivetrain/` - gearbox, wheel, and caster-wheel vocabulary (`DrivetrainDomain`).

## Related Layers

- Electromechanical actuators remain `ElectronicsComponent`-based in `../electronics/`, but import this family's mechanical interconnection vocabulary for their physical outputs.
- Business-domain libraries should compose mechanical concepts for structural and drivetrain implementation detail, the same way they already compose `../electronics/`.

## Modeling Checklist

- Use `core/` for any purely mechanical part that needs to participate in a `sum()`-derived mass rollup.
- Use `interconnection/` for torque/rotation and force/translation boundaries between actuators, transmissions, and loads.
- Use `drivetrain/` when a model needs gear reduction, wheel geometry, or an unpowered caster wheel.
- Prefer `sum()`-derived `mass` at assembly level over hand-typed totals, exactly as `../electronics/` already does for `ElectronicsComponent` (see `examples/mechanical-composition/`).

## Notes

- Mechanical libraries are technical and business-agnostic.
- `MechanicalComponent` deliberately does **not** share a common ancestor with `ElectronicsComponent` (no multi-specialization) — `mass` is independently declared on both. A purely mechanical part specializes `MechanicalComponent`; an electromechanical part (has a port) specializes `ElectronicsComponent` instead, even though it also has mass.
- `MechanicalComponent` carries no `powerDraw` — purely mechanical parts don't draw power. If a part needs both `mass` and `powerDraw`, it isn't purely mechanical and belongs in `../electronics/` instead.
