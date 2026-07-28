# SysML Domain Libraries

This repository provides reusable SysML v2 **vocabulary** for things in the system:

- `domain/` — business-domain vocabulary. Currently empty: the prior `robotics` library was removed (thin scaffolding, no downstream consumers — see Migration Map) while technical-library quality is prioritized before the next domain library is added.
- `technical/` — business-agnostic technical capabilities (software, electronics, communication).
- `generic/` — cross-domain foundation: units (`MonetaryUnits`, `EngineeringUnits`) and part procurement/traceability metadata (`PartProcurement`).

**How** to author, trace, review, and assure models lives in the sibling repository [`mbse-methodology`](../mbse-methodology/README.md) (Elan8 Method). This repository must **not** depend on method packages.

## Where To Start

- Business architecture and mission-level modeling: start in `domain/`.
- Platform, software, communication, and electronics capabilities: start in `technical/`.
- Requirements metadata, method concerns, viewpoints, recipes: sibling [`mbse-methodology`](../mbse-methodology/README.md) (optional; separate product).
- Software and platform capability modeling: start with `technical/software/README.md`.

## Canonical Path Policy

- Import vocabulary from `domain/**`, `technical/**`, and `generic/units/**`.
- Do not import `Elan8*` method packages from this repository.
- Keep new domain/technical libraries and examples under these roots only.
- Do not add systems-engineering / process packages here.

## Validation

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1
```

No sibling `mbse-methodology` checkout is required to validate this repository.
## Migration Map (Legacy -> Canonical)

### Generic foundation

- `technical/systems-engineering/` / `generic/systems-engineering/` → **removed**; use `mbse-methodology/library/` (`Elan8RequirementManagement`, `Elan8RequirementMetadata`, …)
- `technical/units/` → `generic/units/`

### Robotics (removed, 2026-07-28)

- The legacy `robotics/*` packages were migrated to `domain/robotics/*` (as below), then `domain/robotics/` itself was removed entirely: it had no downstream consumers (`sysml-robot-vacuum-cleaner` never imported it) and had not progressed past name/type scaffolding. Technical-library depth and quality are being prioritized before a new domain library is added.
- `robotics/robotics-core/RoboticsCore.sysml` → *(removed)*
- `robotics/robot-structure/RobotStructure.sysml` → *(removed)*
- `robotics/robot-perception/RobotPerception.sysml` → *(removed)*
- `robotics/robot-actuation/RobotActuation.sysml` → *(removed)*
- `robotics/robot-control/RobotControl.sysml` → *(removed)*
- `robotics/robot-autonomy/RobotAutonomy.sysml` → *(removed)*
- `robotics/robot-runtime/RobotRuntime.sysml` → *(removed)*
- `robotics/robot-simulation/RobotSimulation.sysml` → *(removed)*
- `robotics/robot-operations/RobotOperations.sysml` → *(removed)*
- `robotics/robot-safety-assurance/RobotSafetyAssurance.sysml` → *(removed)*

### Software

- `software/distributed-systems/DistributedSystems.sysml` → `technical/software/distributed-systems/DistributedSystems.sysml`
- `software/identity-security-domain/IdentitySecurityDomain.sysml` → `technical/software/security/IdentitySecurityDomain.sysml`
- `software/cyber-assurance-domain/CyberAssuranceDomain.sysml` → `technical/software/security/CyberAssuranceDomain.sysml`
- `software/eu-cyber-resilience-overlay/EuCyberResilienceOverlay.sysml` → `technical/software/security/EuCyberResilienceOverlay.sysml`
- `software/software-control-plane/SoftwareControlPlane.sysml` → `technical/software/delivery-ops/SoftwareControlPlane.sysml`
- `software/software-delivery/SoftwareDelivery.sysml` → `technical/software/delivery-ops/SoftwareDelivery.sysml`
- `software/observability-domain/ObservabilityDomain.sysml` → `technical/software/delivery-ops/ObservabilityDomain.sysml`
- `software/cloud-runtime-domain/CloudRuntimeDomain.sysml` → `technical/software/platform/CloudRuntimeDomain.sysml`
- `software/kubernetes-domain/KubernetesDomain.sysml` → `technical/software/platform/KubernetesDomain.sysml`
- `software/sql-domain/SqlDomain.sysml` → `technical/software/data/SqlDomain.sysml`
- `software/nosql-domain/NosqlDomain.sysml` → `technical/software/data/NosqlDomain.sysml`

## Repository Standards

- Naming and severity conventions: `docs/conventions.md`.
- Repository sanity and acceptance checks: `docs/quality-checks.md`.
- SysML semantic validation: run `powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1`.
- Cross-family examples and expected rule outcomes: see `examples/README.md`.
