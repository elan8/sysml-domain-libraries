# SysML Domain Libraries

This repository provides reusable SysML v2 **vocabulary** for things in the system:

- `domain/` — business-domain vocabulary (e.g. robotics).
- `technical/` — business-agnostic technical capabilities (software, electronics, communication).
- `generic/` — cross-domain foundation units (`MonetaryUnits`, `EngineeringUnits`).

**How** to author, trace, review, and assure models lives in the sibling repository [`mbse-methodology`](../mbse-methodology/README.md) (Elan8 Method). This repository must **not** depend on method packages.

## Where To Start

- Business architecture and mission-level modeling: start in `domain/`.
- Platform, software, communication, and electronics capabilities: start in `technical/`.
- Requirements metadata, method concerns, viewpoints, recipes: sibling [`mbse-methodology`](../mbse-methodology/README.md) (optional; separate product).
- Robotics system modeling: start with `domain/robotics/README.md`.
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

### Robotics

- `robotics/robotics-core/RoboticsCore.sysml` → `domain/robotics/robotics-core/RoboticsCore.sysml`
- `robotics/robot-structure/RobotStructure.sysml` → `domain/robotics/structure/RobotStructure.sysml`
- `robotics/robot-perception/RobotPerception.sysml` → `domain/robotics/perception/RobotPerception.sysml`
- `robotics/robot-actuation/RobotActuation.sysml` → `domain/robotics/actuation/RobotActuation.sysml`
- `robotics/robot-control/RobotControl.sysml` → `domain/robotics/control/RobotControl.sysml`
- `robotics/robot-autonomy/RobotAutonomy.sysml` → `domain/robotics/autonomy/RobotAutonomy.sysml`
- `robotics/robot-runtime/RobotRuntime.sysml` → `domain/robotics/runtime/RobotRuntime.sysml`
- `robotics/robot-simulation/RobotSimulation.sysml` → `domain/robotics/simulation/RobotSimulation.sysml`
- `robotics/robot-operations/RobotOperations.sysml` → `domain/robotics/operations/RobotOperations.sysml`
- `robotics/robot-safety-assurance/RobotSafetyAssurance.sysml` → `domain/robotics/safety-assurance/RobotSafetyAssurance.sysml`

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
