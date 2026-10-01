# Technical Communication Libraries

This directory contains reusable communication capability libraries that are independent from any single business domain.

Use these packages when a model needs protocol, endpoint, channel, binding, or messaging vocabulary that should be shared across software, electronics, robotics, or other domains.

## Best Starting Points

- Start with `Communication.sysml` (`Elan8::Communication`). Nested `Core` holds neutral endpoint, channel, operation, session, and binding concepts. Nested `Wireless` holds the BLE and Wi-Fi overlays.
- Add `http/`, `grpc/`, `messaging/`, or `streaming/` when a model needs a concrete communication style.
- Use `transport/`, `device-bus/`, and `industrial/` as scaffolds for lower-level or field-system communication detail. Wireless overlays are the nested `Wireless` package in `Communication.sysml`.

## Structure

- `Communication.sysml` - `Elan8::Communication`, including nested `Core` and `Wireless`.
- `http/` - HTTP/REST communication overlays (`Elan8::Communication::Http`, `Elan8::Communication::OpenApi`).
- `grpc/` - gRPC communication overlays (`Elan8::Communication::Grpc`).
- `messaging/` - asynchronous messaging overlays (`Elan8::Communication::Messaging`).
- `streaming/` - streaming broker specializations (`Elan8::Communication::Kafka`).
- `transport/` - transport protocol scaffolds (TCP/UDP).
- `device-bus/` - device and field bus scaffolds (USB).
- `industrial/` - industrial protocol scaffolds (Modbus/Profinet/EtherCAT).

## Notes

- Communication libraries are technical and business-agnostic.
- Software and business-domain libraries should import these communication libraries rather than redefining protocol concepts.
- Public packages use short names below `Elan8::Communication`.
- Use operation contracts and serialization payloads when operations exchange structured input, output, or error data.
- For robotics or runtime models, use `CommunicationEndpoint`, `CommunicationChannel`, and `CommunicationBinding` to connect runtime communication intent to concrete protocol or transport detail.

## Modeling Checklist

- Model endpoints when a system crosses a process, network, device, or runtime boundary.
- Model channels for telemetry, command, event, or session paths.
- Model bindings when an operation depends on an endpoint, channel, session, or protocol context.
- Add serialization contracts when payload structure matters for validation or integration.
