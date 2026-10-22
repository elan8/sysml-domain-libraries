# Service and messaging patterns

Read the [interaction guide](../../../../../docs/software-interactions.md) for the
modeling conventions, normative references and protocol sources.

| Model | Purpose |
| --- | --- |
| [GrpcServices.sysml](GrpcServices.sysml) | Three RPC signatures, typed action references, two services per endpoint, explicit server implementation bindings, client service conjugation and separate unary HTTP/2 transport mappings |
| [KafkaEvents.sysml](KafkaEvents.sysml) | Typed event publication, topic binding, an external Kafka/log boundary and two classic consumer groups |
| [MessageBus.sysml](MessageBus.sysml) | In-process event-dispatch topology with two subscribers, without assumed storage or buffering |

`GrpcServices.sysml` links [robot.proto](robot.proto) as its wire-contract
counterpart. Its `InterfaceSpec` URI is repository-root-relative by convention.
The schema lists two services and three unary methods; no streaming lifecycle
or generated stubs are supplied. Check it with `protoc` separately when available.

The RPC example's provider-side `in ref action` convention describes references
to logical call performances, not the transmission of action objects. Bindings
to implementing actions express identity. Port connections do not automatically
invoke those actions. HTTP allocations record realization intent without
implementing encoding or dispatch. The HTTP response abstraction keeps gRPC
completion status distinct from HTTP status.

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
