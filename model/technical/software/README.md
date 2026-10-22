# Software Library

`Elan8::Software` holds the generic software concepts that code generators, verifiers and timing
analyses act on. The design behind it is in [docs/library-design.md](../../../docs/library-design.md).

The [software modeling guide](../../../docs/software-modeling.md) explains common
concepts and language mappings for C#, Python, Rust, C/C++, Java and
TypeScript/JavaScript, including the distinction between architecture, source,
build and runtime structure.

The [interaction guide](../../../docs/software-interactions.md) explains RPC
references in service ports, implementation bindings, endpoints containing several
services, HTTP transport mappings, Kafka events and in-process message buses.

## Contents

- `Software.sysml` (`Elan8::Software`)
  - **Components:** `SoftwareComponent` (keyword `#software`), and the `#external` marker for
    components realised outside the project. `SoftwareApplication` and `SoftwareLayer`
    specialize `SoftwareComponent` for application boundaries and architectural layers;
    `SoftwareModule` represents implementation units such as repositories and adapters.
  - **Service contracts:** `SoftwareServiceContract` groups callable operation contracts
    independently of the components implementing them and their transport bindings.
  - **Operations:** `SoftwareOperation`, `QueryOperation` (`#query`) and `CommandOperation`
    (`#command`), plus the `#idempotent` marker. A query has no effect outside its own execution;
    a command may change state.
  - **Interaction ports:** `RequestReplyPort` (`#call`), `MessagePort` (`#oneway`) and `StreamPort`
    (`#stream`). An interface specialises one and redefines its payload items.
  - **Timing and deployment:** `Task`, `PeriodicTask` and `EventDrivenTask` (`#task`),
    `ExecutionPlatform` (`#platform`) with its scheduling policy. Deployment is
    `allocate task to platform;`.
  - **Data resources:** `SoftwareQueue` buffers messages with a capacity and discipline;
    `SoftwareDataStore` holds retrievable data with optional storage capacity and persistence.
    Both specialize `SoftwareComponent`.
- `bindings/Bindings.sysml` (`Elan8::Software::Bindings`): technology choices as metadata: `Rpc`,
  `HttpRoute`, `Topic`, `CanFrame` and `Container`.

Code generation views, formal verification options and links to source code and interface
specifications are in `Elan8::Generation` (`model/generic/generation/`).

## Applications, layers and components

`SoftwareComponent` is independent of implementation granularity: a component may
be implemented by many C# classes, for example. It can compose other components.
It is already abstract. The library kinds are useful specializations, not a closed
taxonomy: projects can define concrete specializations directly when no existing
kind fits. `SoftwareModule` is the usual base for cohesive implementation units;
it does not imply a particular file, class, assembly or deployment boundary.
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

## Service contracts and implementations

`SoftwareServiceContract` is an abstract part definition separate from
`SoftwareComponent`. It groups action usages typed by `SoftwareOperation`
definitions and carries their obligations. An implementation can specialize a
project contract together with `SoftwareModule` to inherit its signatures and
constraints. Different implementations can share the same contract.

The layered example defines `SettingsServiceContract` with load/save operations;
`SettingsRepository` specializes both that contract and `SoftwareModule`.
Neither specialization nor an action's name automatically exposes it on a port.
Service exposure, transport binding and request-dispatch behavior remain explicit
modeling concerns. Native typed action references in port definitions and explicit
contextual bindings can express a logical callable boundary; the interaction
guide documents the provider/client convention and its limits. This does not
require a separate port per RPC or a generated provided/required-service mechanism.

## Datastores and queues

`SoftwareDataStore` is a logical data resource: a database, settings file or
in-memory store. A project adds its record schema as typed items and defines
access interfaces and operations as needed. Its optional `capacity` is a
`StorageCapacityValue` in information units, not a number of records.
`persistence` is either `DataStorePersistence::volatile` or `persistent`;
omitting it leaves the property unspecified. Persistent storage does not by
itself establish transaction guarantees, power-loss durability or retention rules.

A repository is a module accessing a datastore, not the datastore itself. A
database server is an execution/deployment concern, and a disk or flash device
is physical storage. Keep those boundaries separate and model hosting or
implementation mappings when relevant.

The application normally owns its datastore once; repositories use `ref part`
references bound to that occurrence. The layered example shows this shared-resource
pattern. `SoftwareQueue` instead buffers messages for delivery or consumption;
its `capacity` remains a message count and its existing queue disciplines are unchanged.

## Native SysML, not library definitions

State machines, events, messages and interactions are native SysML: `state`, `item def` payloads with
`send` and `accept`, and successions. The library does not re-model them.

## Examples

- `examples/interactions/`: reference-based gRPC service ports, explicit
  implementation bindings and HTTP mappings, Kafka event/log topology, and an
  in-process message bus. Protocol endpoint definitions are local to the examples.

- `examples/language-mappings/`: paired SysML and source examples for a C# class
  and callable contract, a Python module/script and a Rust crate with modules,
  free functions and receiver methods. See its README for validation limits.

- `examples/layered-application/`: two applications, Services/Infrastructure/HAL
  composition, reusable layer colors, a service contract and repository implementation,
  a referenced persistent datastore, runtime interfaces and explicit inventory
  and architecture view selections. The architecture could be implemented in C#;
  it does not prescribe a class, project or assembly mapping.
- `examples/webshop/`: services with queries and commands, request-reply and one-way ports,
  technology bindings, an implemented state machine, a code generation view and a formally verified
  requirement.
- `examples/motor-controller/`: periodic and event-driven tasks with their timing, a bounded queue,
  an execution platform allocated to a microcontroller, and a firmware generation view.
