# Software Technical Libraries

This directory contains technical SysML v2 software capabilities that can be reused across business domains.

Use these packages for service architecture, platform/runtime modeling, delivery operations, security, and data persistence.

## Best Starting Points

- Start with `software-core/SoftwareCore.sysml` for shared software vocabulary.
- Add `distributed-systems/DistributedSystems.sysml` for service and dependency modeling.
- Add `platform/` for cloud and Kubernetes deployment capabilities.
- Add `delivery-ops/` for release, control-plane, and observability concerns.
- Add `security/` for identity and cyber-assurance overlays.
- Add `data/` for relational and non-relational persistence vocabulary.

## Structure

- `software-core/SoftwareCore.sysml` - shared software entities, interfaces, and deployment primitives
- `distributed-systems/DistributedSystems.sysml` - services, boundaries, dependencies, events, and brokers
- `platform/CloudRuntimeDomain.sysml` - cloud runtime and execution context vocabulary
- `platform/KubernetesDomain.sysml` - Kubernetes workload and cluster vocabulary
- `delivery-ops/SoftwareControlPlane.sysml` - control-plane orchestration vocabulary
- `delivery-ops/SoftwareDelivery.sysml` - delivery pipeline and release vocabulary
- `delivery-ops/ObservabilityDomain.sysml` - telemetry, traces, and SLO/SLA vocabulary
- `security/IdentitySecurityDomain.sysml` - identity, authn/authz, and trust boundary vocabulary
- `security/CyberAssuranceDomain.sysml` - security control and assurance vocabulary
- `security/EuCyberResilienceOverlay.sysml` - CRA-focused compliance overlay vocabulary
- `data/SqlDomain.sysml` - relational persistence vocabulary
- `data/NosqlDomain.sysml` - non-relational persistence vocabulary

## Package Guidance

### distributed-systems

- **When to use:** service boundaries, API ownership, and deployment dependency reasoning.
- **Anti-patterns:** direct coupling without interface ownership, implicit external boundaries.
- **Minimum checklist:** service interfaces modeled, deployment allocation visible, dependency graph acyclic.

### platform

- **When to use:** cloud runtime constraints, multi-environment deployment, and workload placement.
- **Anti-patterns:** runtime abstraction without host/runtime metadata, environment assumptions left implicit.
- **Minimum checklist:** runtime and node identity modeled, target environment named, deployable artifacts linked.

### delivery-ops

- **When to use:** release governance, operational policy, and observability requirements.
- **Anti-patterns:** delivery flow without policy gates, telemetry obligations not represented.
- **Minimum checklist:** release/control ownership modeled, policy checks declared, observability signals defined.

### security

- **When to use:** identity lifecycle, trust boundaries, control inheritance, and compliance overlays.
- **Anti-patterns:** authentication modeled without authorization context, controls with no assurance evidence path.
- **Minimum checklist:** identity actors and trust boundaries declared, controls mapped to assets, assurance responsibilities explicit.

### data

- **When to use:** persistence strategy, data ownership boundaries, and consistency trade-off communication.
- **Anti-patterns:** data stores modeled without owning services, mixed consistency assumptions left implicit.
- **Minimum checklist:** store ownership defined, data classification captured, consistency/retention intent stated.

## Rules And Quality

- Rule catalogs live beside each package in `rules/`.
- Severity interpretation and naming standards are defined in `docs/conventions.md`.
- Start with warning-level hygiene, then enforce error-level production gates in CI.
