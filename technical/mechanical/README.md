# Mechanical Technical Libraries

This directory contains technical mechanical capability libraries intended for reuse across multiple business domains.

Use these packages when a model needs vocabulary for purely mechanical components — parts with mass but no electrical characteristics — while keeping business-domain semantics outside the mechanical layer.

## Best Starting Points

- Start with `mechanical-core/` for the shared `MechanicalComponent` base.
- Add `drivetrain/` for gearbox, wheel, and caster-wheel vocabulary.

## Structure

- `mechanical-core/` - base mechanical concept (`MechanicalCore`), providing `mass` on `MechanicalComponent` for budget rollups.
- `drivetrain/` - gearbox, wheel, and caster-wheel vocabulary (`DrivetrainDomain`).

## Related Layers

- Electromechanical parts that produce an electrical signal (bumper/lift switches, encoders, motors) are `ElectronicsComponent`-based and live in `../electronics/`, not here — this family is for parts with **no** electrical characteristics at all.
- Business-domain libraries should compose mechanical concepts for structural and drivetrain implementation detail, the same way they already compose `../electronics/`.

## Modeling Checklist

- Use `mechanical-core/` for any purely mechanical part that needs to participate in a `sum()`-derived mass rollup.
- Use `drivetrain/` when a model needs gear reduction, wheel geometry, or an unpowered caster wheel.
- Prefer `sum()`-derived `mass` at assembly level over hand-typed totals, exactly as `../electronics/` already does for `ElectronicsComponent` (see `examples/mechanical-composition/`).

## Notes

- Mechanical libraries are technical and business-agnostic.
- `MechanicalComponent` deliberately does **not** share a common ancestor with `ElectronicsComponent` (no multi-specialization) — `mass` is independently declared on both. A purely mechanical part specializes `MechanicalComponent`; an electromechanical part (has a port) specializes `ElectronicsComponent` instead, even though it also has mass.
- `MechanicalComponent` carries no `powerDraw` — purely mechanical parts don't draw power. If a part needs both `mass` and `powerDraw`, it isn't purely mechanical and belongs in `../electronics/` instead.
