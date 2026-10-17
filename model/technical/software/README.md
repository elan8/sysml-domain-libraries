# Software Library

`Elan8::Software` holds the generic software concepts that code generators, verifiers and timing
analyses act on. The design behind it is in [docs/library-design.md](../../../docs/library-design.md).

## Contents

- `Software.sysml` (`Elan8::Software`)
  - **Components:** `SoftwareComponent` (keyword `#software`), and the `#external` marker for
    components realised outside the project.
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

## Native SysML, not library definitions

State machines, events, messages and interactions are native SysML: `state`, `item def` payloads with
`send` and `accept`, and successions. The library does not re-model them.

## Examples

- `examples/webshop/`: services with queries and commands, request-reply and one-way ports,
  technology bindings, an implemented state machine, a code generation view and a formally verified
  requirement.
- `examples/motor-controller/`: periodic and event-driven tasks with their timing, a bounded queue,
  an execution platform allocated to a microcontroller, and a firmware generation view.
