# Software Library

`Elan8::Software` holds the generic software concepts that code generators, verifiers and timing
analyses act on. The design behind it is in [docs/library-design.md](../../../docs/library-design.md).

## Contents

- `Software.sysml` (`Elan8::Software`)
  - **Components:** `SoftwareComponent` (keyword `#software`), and the `#external` marker for
    components realised outside the project. `SoftwareApplication` and `SoftwareLayer`
    specialize `SoftwareComponent` for application boundaries and architectural layers.
  - **Operations:** `SoftwareOperation`, `QueryOperation` (`#query`) and `CommandOperation`
    (`#command`), plus the `#idempotent` marker. A query has no effect outside its own execution;
    a command may change state.
  - **Interaction ports:** `RequestReplyPort` (`#call`), `MessagePort` (`#oneway`) and `StreamPort`
    (`#stream`). An interface specialises one and redefines its payload items.
  - **Timing and deployment:** `Task`, `PeriodicTask` and `EventDrivenTask` (`#task`),
    `ExecutionPlatform` (`#platform`) with its scheduling policy, and `SoftwareQueue` with its
    capacity and discipline. Deployment is `allocate task to platform;`.
- `bindings/Bindings.sysml` (`Elan8::Software::Bindings`): technology choices as metadata: `Rpc`,
  `HttpRoute`, `Topic`, `CanFrame` and `Container`.

Code generation views, formal verification options and links to source code and interface
specifications are in `Elan8::Generation` (`model/generic/generation/`).

## Applications, layers and components

`SoftwareComponent` is independent of implementation granularity: a component may
be implemented by many C# classes, for example. It can compose other components.
`SoftwareApplication` identifies a cohesive application boundary; it does not imply
one process, executable, assembly or deployment unit. `SoftwareLayer` identifies a
logical architectural boundary such as Services, Infrastructure or HAL.

Use composition for application/layer/component membership. An application may
also compose components directly. Use allocation when layer membership is a
separate mapping over components owned elsewhere; do not duplicate composition
with an allocation. Runtime interactions use ports and connections. Source
dependencies and allowed layer dependencies are separate architectural claims;
neither containment nor color establishes them.

```sysml
part def ServicesLayer :> Elan8::Software::SoftwareLayer {
    attribute :>> color default = "#DCEBFA";
    part mission : MissionService;
}
part def RobotApplication :> Elan8::Software::SoftwareApplication {
    part services : ServicesLayer;
}
```

`SoftwareLayer.color` is an optional `String[0..1]` rendering hint. Its documented
format is `#RRGGBB`: six hexadecimal digits, case insensitive, without alpha or
named colors. This is a format convention, not an executable string constraint.
Set it with `default =` on a definition to reuse the same color across occurrences
and allow occurrence overrides. Use `=` for a fixed color that cannot be overridden. An unset color leaves styling to the renderer's theme.
Renderers must explicitly support reading the attribute; adding it does not change
existing diagram styling automatically.

View tooling can discover application and layer occurrences through their types'
semantic specialization of `SoftwareApplication` and `SoftwareLayer`. A layered
diagram follows composition, or allocations for the alternative mapping approach.
Stacked bands, ordering and color interpretation remain renderer responsibilities.

## Native SysML, not library definitions

State machines, events, messages and interactions are native SysML: `state`, `item def` payloads with
`send` and `accept`, and successions. The library does not re-model them.

## Examples

- `examples/layered-application/`: two applications, Services/Infrastructure/HAL
  composition, reusable layer colors, runtime interfaces and explicit inventory
  and architecture view selections. The architecture could be implemented in C#;
  it does not prescribe a class, project or assembly mapping.
- `examples/webshop/`: services with queries and commands, request-reply and one-way ports,
  technology bindings, an implemented state machine, a code generation view and a formally verified
  requirement.
- `examples/motor-controller/`: periodic and event-driven tasks with their timing, a bounded queue,
  an execution platform allocated to a microcontroller, and a firmware generation view.
