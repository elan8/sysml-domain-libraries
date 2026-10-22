# Modeling software services and messaging

This guide distinguishes a callable interface, its implementation, messages and
the transport carrying them. It complements the [software modeling guide](software-modeling.md).
The [interaction examples](../model/technical/software/examples/interactions/README.md)
are checked with the repository's pinned SysML tool. All protocol-specific endpoint
definitions in these examples are project definitions, not additional library types.

## 1. Choose the contract being modeled

| Concern | Representation |
| --- | --- |
| RPC behavior/signature | `action def` specializing `SoftwareOperation`, `QueryOperation` or `CommandOperation` |
| Operation role at a boundary | Typed undirected referential action usage inside a port definition |
| Logical service interface | `port def` grouping related referential RPC actions |
| Endpoint offering several services | Composite port definition with nested service ports |
| Client/server role | Explicit endpoint-role metadata in the example, separate from action direction |
| Implementing software | `SoftwareModule` with owned operation usages |
| Implementation relationship | Explicit contextual binding between port action references and implementing actions |
| Reusable implementation-independent behavior obligations | `SoftwareServiceContract`, when useful separately from the port interface |
| Event/command payload | `item def` with typed fields |
| One-way publishing/subscription | `MessagePort` specialization and conjugated subscriber port |
| Broker or dispatcher | Explicit software component when its responsibility matters |
| Stored event log | `SoftwareDataStore` specialization, distinct from a queue |
| Transport choice | Metadata and a documented mapping to a separate transport boundary |

These are different modeling questions. A service implementation, a callable
service port and an HTTP endpoint need not be the same element. Similarly, an
event, topic, broker, subscription and consumer group are not interchangeable.

## 2. Can a port contain `ref action`?

Yes. SysML v2.0 Part 1 section 7.12.2 permits features in a port definition but
requires non-port features to be referential. The corresponding semantic rule is
`validatePortDefinitionNestedUsagesNotComposite` in section 8.4.8.1. An explicitly
referential action usage meets that requirement. This is a native language pattern,
not a tool-specific operation-port extension.

```sysml
action def GetStatus :> QueryOperation {
    in request : GetStatusRequest;
    out response : RobotStatus;
}
port def RobotControlService :> InteractionPort {
    ref action getStatus : GetStatus[0..*];
}
```

The name after `ref action` is a usage name; `: GetStatus` gives its signature
through the reusable action definition. An untyped `ref action GetStatus;` would
declare a new action reference named `GetStatus`; it would not reference the
existing definition merely because the names match.

The `[0..*]` multiplicity allows references to repeated logical call performances.
The reference itself has no direction. Its operation definition still has input
request and output response parameters. Those directions describe the operation
signature; they are separate from whether an endpoint acts as client or server.
Adding `in` would direct the action reference, not declare a provided operation
or describe the RPC's entire request/response exchange.

The example records client/server roles explicitly with project-local
`GrpcEndpointRole` metadata on the endpoint occurrences. Both use the same
`GrpcEndpoint` definition. Conjugation reverses directed features, so it does not
establish client/server roles for these undirected action references. Neither the
role annotation nor the reference itself supplies RPC dispatch semantics.

An action reference refers to a behavior performance, not a static source-code
method pointer or serialized method name. This pattern expresses a logical call
boundary. It does not mean action objects are transmitted over the network.
It also does not specify invocation scheduling, concurrency, completion or errors.

Normative baseline: [OMG SysML v2.0, Part 1](https://www.omg.org/spec/SysML/2.0/Language/PDF),
sections 7.12.2, 7.17 and 8.4.8.1. The local reference used for this work is the
March 2026 language specification, OMG `formal/2026-03-02`.

## 3. Relate the boundary to the implementation

The [gRPC example](../model/technical/software/examples/interactions/GrpcServices.sysml)
owns the implementation's operations in `RobotHandler`. In the server context it
binds the exposed action reference to the corresponding owned action feature:

```sysml
bind grpc.robotControl.getStatus = handler.getStatus;
```

This claims that these features identify the same logical performances. Merely
giving the two features the same name or type would not establish that relationship.
Use this binding only when identity is intended. If an adapter performs validation,
authorization or transformation before invoking another operation, model separate
behaviors and their call/data mappings; do not bind distinct performances as equal.

A connection between client and server ports enables interaction but does not
execute an operation. Native performed actions, parameter bindings, control flow,
states and requirements provide detailed call behavior when needed. The example
shows interface/implementation structure, not an executable RPC runtime.

`SoftwareServiceContract` remains useful for reusable callable obligations shared
by implementations independently of transport. It is not required merely to group
RPC references in a port. Reuse authoritative action definitions for signatures
instead of maintaining separate signature copies in each representation.

## 4. Several services on one endpoint

The example groups `RobotControlService` and `DiagnosticsService` under a
`GrpcEndpoint` port definition. Client and server use that same contract, with
explicit role annotations on their endpoint occurrences. Connections are made
between corresponding service ports; the HTTP transport is shown separately.
The server binds its RPC references to the handler's implementing actions. The
client annotation identifies the consuming endpoint without reversing the
operation's request/response signature. For a mixed-role aggregate, record the
roles on individual service endpoint occurrences instead.

In the example's [Protobuf contract](../model/technical/software/examples/interactions/robot.proto):

| SysML service/operation | Protobuf symbol |
| --- | --- |
| `RobotControlService.getStatus` | `demo.robot.v1.RobotControl.GetStatus` |
| `RobotControlService.startCleaning` | `demo.robot.v1.RobotControl.StartCleaning` |
| `DiagnosticsService.getDiagnostics` | `demo.robot.v1.DiagnosticsService.GetDiagnostics` |

`InterfaceSpec` links the schema; `Rpc` identifies gRPC and the streaming mode.
These annotations record bindings, not generated dispatch or schema-conformance
checks. Names in the table are explicit project mappings. The `.proto` remains
authoritative for serialization details such as field numbers and wire types.

## 5. Map gRPC to HTTP transport

gRPC carried over HTTP/2 has a wire protocol with method paths, request/response
messages and completion status. A method uses a path containing its fully qualified
service and method name, and gRPC completion status is distinct from HTTP status.
See the [gRPC HTTP/2 protocol](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md).

Keep the logical service endpoint and the HTTP transport endpoint separate when
both abstraction levels matter. The example uses:

```sysml
allocate grpc to http2;
```

Here allocation is an explicitly documented logical-to-transport realization
mapping on both client and server. Native allocation is general enough to record
that assignment, but it does not implement HTTP framing, Protobuf encoding,
routing, security or retry logic. No new library-specific transport allocation
type is implied.

Do not use `bind grpc = http2;`: those endpoints describe different interfaces
and values. Bindings are appropriate for same-interface delegation or action
identity; transformations need behavior. If stack responsibilities are important,
model client/server adapters as modules, expose their logical and transport ports,
and model encoding, dispatch and response handling explicitly.

The example's `UnaryHttp2Endpoint` is a deliberately limited request/reply
abstraction. It does not model HTTP/2 multiplexing, headers, framing or streaming.
Its client port is conjugated because this transport contract has directed
request/response data features; this is distinct from the undirected RPC references.
Its logical service connections and HTTP connection are two views of one
interaction, not additional independent calls.

An HTTP/JSON API exposing the same business operation is a different binding.
Use `HttpRoute` for that route and model the gateway/transcoding behavior when it
bridges to gRPC. A logical query does not imply HTTP GET for a gRPC method.
gRPC-Web or a proxy deployment needs its own concrete transport assumptions.

## 6. Unary and streaming calls

The library's `StreamingKind` represents unary, server-streaming, client-streaming
and bidirectional RPCs. gRPC preserves message order within an individual stream;
the bidirectional streams operate independently. See [gRPC core concepts](https://grpc.io/docs/what-is-grpc/core-concepts/).

For streaming behavior, model message occurrences, direction, ordering, completion,
cancellation, deadlines, buffering and backpressure when they matter. An output
item with multiplicity `[0..*]` alone describes a collection, not a stream's
lifecycle. `StreamPort` currently represents continuous samples; it is not a
complete gRPC streaming contract. The supplied gRPC fixture is unary only.

Distinguish application response/error data from RPC status and transport failure.
A retry may repeat an operation; identify idempotency or deduplication assumptions
instead of inferring them from the method name.

## 7. Kafka events

Use an item definition for event data and a typed one-way port for its publication.
The [Kafka example](../model/technical/software/examples/interactions/KafkaEvents.sysml)
annotates the publisher's selected port with `Topic` metadata: broker kind, topic
name and key-field name. Consumer ports use the conjugated payload interface.

The model includes an external Kafka boundary, a persistent topic-log resource,
and two consumers with different classic consumer-group names. Group attributes
are project-local configuration, not a new generic consumer-group library type.
Topology alone neither delivers records nor verifies that configurations agree.

Kafka's partition logs, consumer positions and replay differ from a destructive
work queue. In classic consumer groups, a partition is assigned to one consumer
in a group at a time; separate groups consume independently. Ordering is per
partition, not a total order across a topic. Broker/producer/consumer configuration
and processing determine delivery and transaction guarantees. See the
[Apache Kafka design documentation](https://kafka.apache.org/41/design/design/).

When relevant, author explicit requirements or deployment configuration for:

- Topic schema/version, partition key and partition count.
- Consumer-group membership, offsets and replay behavior.
- Retention/compaction, authorization and data ownership.
- Acknowledgment/commit timing, retries and duplicate handling.
- Ordering boundaries, lag limits, dead-letter handling and recovery.
- The scope of transaction or exactly-once processing claims.

The current `Topic` metadata does not contain all these fields, and its presence
does not establish any delivery guarantee. Link authoritative configuration or
add identified project metadata for actual analysis needs. A topic log can be a
`SoftwareDataStore`; an application's bounded handoff buffer can separately be a
`SoftwareQueue`. Their capacities and consumption semantics are different.

## 8. Message buses, queues and events

The [message-bus example](../model/technical/software/examples/interactions/MessageBus.sysml)
shows an in-process dispatcher connecting one publisher to two subscribers. The
bus is a software module because it has an explicit routing responsibility.
It assumes neither persistent storage nor a queue merely because events exist.

| Pattern | Important contract |
| --- | --- |
| In-process dispatch | Handler selection, invocation order, reentrancy and threading |
| Publish/subscribe broker | Routing, subscription scope and independent delivery |
| Work queue | Competing consumers, acknowledgment, redelivery and buffer bounds |
| Replayable event log | Retention, positions, replay and partitioned ordering |
| Request/reply over messaging | Correlation IDs, reply routing, timeout and duplicate handling |

A command asks for an effect; an event reports something that happened. Both
can use one-way messaging, but their contracts differ. Use native `send`, `accept`,
flows and handling actions to model actual delivery/processing behavior. A port
connection alone supplies topology. For an asynchronous request/reply pattern,
model correlation and two-way behavior explicitly rather than silently assuming
the synchronous `RequestReplyPort` contract.

## 9. What the examples prove

The full workspace check validates definitions, typing, referential port features,
endpoint-role metadata, implementation bindings, transport allocations and
broker/bus topology. Semantic export checks inspect those authored relationships.

The fixtures do not prove generated gRPC implementation behavior, Protobuf wire
compatibility, HTTP/2 correctness or Kafka delivery guarantees. The `.proto` file
is a source counterpart; it requires a separate Protobuf compiler/schema check.
No renderer or generator is assumed to implement these project conventions.
