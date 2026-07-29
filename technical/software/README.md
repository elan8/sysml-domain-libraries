# Software Technical Libraries

This directory contains technical SysML v2 software capabilities that can be reused across business domains.

Use these packages for service architecture, platform/runtime modeling, delivery operations, security, and data persistence.

## Best Starting Points

- Start with `core/SoftwareCore.sysml` (`Elan8::Software::Core`) for shared software vocabulary.
- Add `distributed-systems/DistributedSystems.sysml` for service and dependency modeling.
- Add `platform/` for cloud and Kubernetes deployment capabilities.
- Add `delivery-ops/` for release, control-plane, and observability concerns.
- Add `security/` for identity and cyber-assurance overlays.
- Add `data/` for relational and non-relational persistence vocabulary.
- Add `realtime-runtime/` for real-time task, queue, and scheduler vocabulary (embedded or otherwise).
- For method-style requirement roles and traceability metadata, use sibling `mbse-methodology` optionally; software vocabulary does not depend on it.
- Add `../communication/` when software interfaces need protocol, endpoint, channel, or payload contracts.

## Structure

- `core/SoftwareCore.sysml` (`Elan8::Software::Core`) - shared software entities, interfaces, and deployment primitives
- `distributed-systems/DistributedSystems.sysml` (`Elan8::Software::Distributed`) - services, boundaries, dependencies, events, and brokers
- `platform/CloudRuntimeDomain.sysml` (`Elan8::Software::Platform::Cloud`) - cloud runtime and execution context vocabulary
- `platform/KubernetesDomain.sysml` (`Elan8::Software::Platform::Kubernetes`) - Kubernetes workload and cluster vocabulary
- `delivery-ops/SoftwareControlPlane.sysml` - control-plane orchestration vocabulary
- `delivery-ops/SoftwareDelivery.sysml` - delivery pipeline and release vocabulary
- `delivery-ops/ObservabilityDomain.sysml` - telemetry, traces, and SLO/SLA vocabulary
- `interactions/SoftwareInteractions.sysml` (`Elan8::Software::Interactions`) - sequence and interaction modeling vocabulary
- `security/IdentitySecurityDomain.sysml` - identity, authn/authz, and trust boundary vocabulary
- `security/CyberAssuranceDomain.sysml` - security control and assurance vocabulary
- `security/EuCyberResilienceOverlay.sysml` - CRA-focused compliance overlay vocabulary
- `data/SqlDomain.sysml` (`Elan8::Software::Data::Sql`) - relational persistence vocabulary
- `data/NosqlDomain.sysml` (`Elan8::Software::Data::NoSql`) - non-relational persistence vocabulary
- `realtime-runtime/RealtimeRuntime.sysml` (`Elan8::Software::Realtime`) - real-time task, queue, and scheduler vocabulary

## Package Guidance

### core

- **When to use:** shared components, modules, source artifacts, interfaces, operation-effect classification, and capability-to-implementation traceability.
- **Anti-patterns:** operation interfaces whose read-only, command, analysis, or mutating intent is implicit; capability models disconnected from implementation structure.
- **Minimum checklist:** externally consumed operations identify their effect kind, and exposed capabilities identify implementing components or source artifacts when traceability matters.

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

### realtime-runtime

- **When to use:** periodic/deadline-driven tasks, bounded inter-task queues, and scheduler policy — embedded firmware or any other real-time software.
- **Anti-patterns:** timing budgets (period, deadline, worst-case execution time) left implicit; queue overflow behavior unspecified.
- **Minimum checklist:** each task's period/deadline/criticality stated, each queue's depth/discipline stated, a scheduler model declared.

## Quality

- Validate SysML syntax and semantic consistency with `scripts/validate-spec42.ps1`.
- Use the package guidance checklists above for modeling completeness until executable software-domain checks are available.
- Do not add non-executable YAML rule catalogs; encode enforceable checks in Spec42 or another real validator first.
