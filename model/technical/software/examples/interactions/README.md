# Service and messaging patterns

Read the [interaction guide](../../../../../docs/software-interactions.md) for the
modeling conventions, normative references and protocol sources.

| Model | Purpose |
| --- | --- |
| [GrpcServices.sysml](GrpcServices.sysml) | Structured attribute data schemas, nested optional data, attribute-valued RPC parameters, undirected action references, explicit endpoint roles and implementation/HTTP mappings |
| [KafkaEvents.sysml](KafkaEvents.sysml) | Typed event publication, topic binding, an external Kafka/log boundary and two classic consumer groups |
| [MessageBus.sysml](MessageBus.sysml) | In-process event-dispatch topology with two subscribers, without assumed storage or buffering |

`GrpcServices.sysml` links [robot.proto](robot.proto) as its wire-contract
counterpart. Its `InterfaceSpec` URI is repository-root-relative by convention.
The schema lists two services and three unary methods; no streaming lifecycle
or generated stubs are supplied. Check it with `protoc` separately when available.

Protobuf messages map to structured `attribute def`s named with a `Data` suffix.
`RobotStatusData.position : PositionData[0..1]` demonstrates an embedded message
value with presence. All six RPC parameters are explicit attribute usages.
They do not require item envelopes. The HTTP request/reply item definitions model
transport occurrences separately; the Kafka and bus fixtures also retain their
occurrence-oriented payload models.

The new `position` field uses Protobuf field number 2; the existing `cleaning`
field remains number 1. SysML `Real` abstracts Protobuf `double`; wire precision,
presence/default handling and schema compatibility require separate binding checks.

The RPC example uses undirected `ref action` features to refer to logical call
performances, not the transmission of action objects. Its project-local
`GrpcEndpointRole` metadata identifies client/server roles independently of the
operation's request/response parameter directions. Conjugating these undirected
RPC references would not establish an endpoint role. Bindings
to implementing actions express identity. Port connections do not automatically
invoke those actions. HTTP allocations record realization intent without
implementing encoding or dispatch. The HTTP response abstraction keeps gRPC
completion status distinct from HTTP status.
The HTTP client port remains conjugated because its transport contract has
directed request/response data features.

The Kafka and bus examples describe boundaries and topology, not implementations
of delivery, polling, offsets, acknowledgment, routing or handling. Kafka consumer
group configuration is represented by project-local attributes. Broker metadata
does not establish transport or delivery guarantees.

From the repository root, run:

```sh
python scripts/validate_spec42.py
```

The repository's standard KPAR bundle excludes these examples. Their endpoint
definitions are project-local and do not add new public domain-library types.
