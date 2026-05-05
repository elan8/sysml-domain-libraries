# SysML Domain Libraries

This repository provides reusable SysML v2 libraries organized by modeling intent:

- `domain/` for business-domain vocabulary.
- `technical/` for business-agnostic technical capabilities.

Use these two roots as canonical import sources.

## Where To Start

- Business architecture and mission-level modeling: start in `domain/`.
- Platform, software, communication, and electronics capabilities: start in `technical/`.
- Robotics system modeling: start with `domain/robotics/README.md`.
- Software and platform capability modeling: start with `technical/software/README.md`.

## Canonical Path Policy

- Prefer imports from `domain/**` and `technical/**`.
- Treat legacy root paths as deprecated and migrate references to canonical roots.
- Keep new libraries and examples under canonical roots only.

## Migration Map (Legacy -> Canonical)

### Robotics

- `robotics/robotics-core/RoboticsCore.sysml` -> `domain/robotics/robotics-core/RoboticsCore.sysml`
- `robotics/robot-structure/RobotStructure.sysml` -> `domain/robotics/structure/RobotStructure.sysml`
- `robotics/robot-perception/RobotPerception.sysml` -> `domain/robotics/perception/RobotPerception.sysml`
- `robotics/robot-actuation/RobotActuation.sysml` -> `domain/robotics/actuation/RobotActuation.sysml`
- `robotics/robot-control/RobotControl.sysml` -> `domain/robotics/control/RobotControl.sysml`
- `robotics/robot-autonomy/RobotAutonomy.sysml` -> `domain/robotics/autonomy/RobotAutonomy.sysml`
- `robotics/robot-runtime/RobotRuntime.sysml` -> `domain/robotics/runtime/RobotRuntime.sysml`
- `robotics/robot-simulation/RobotSimulation.sysml` -> `domain/robotics/simulation/RobotSimulation.sysml`
- `robotics/robot-operations/RobotOperations.sysml` -> `domain/robotics/operations/RobotOperations.sysml`
- `robotics/robot-safety-assurance/RobotSafetyAssurance.sysml` -> `domain/robotics/safety-assurance/RobotSafetyAssurance.sysml`

### Software

- `software/distributed-systems/DistributedSystems.sysml` -> `technical/software/distributed-systems/DistributedSystems.sysml`
- `software/identity-security-domain/IdentitySecurityDomain.sysml` -> `technical/software/security/IdentitySecurityDomain.sysml`
- `software/cyber-assurance-domain/CyberAssuranceDomain.sysml` -> `technical/software/security/CyberAssuranceDomain.sysml`
- `software/eu-cyber-resilience-overlay/EuCyberResilienceOverlay.sysml` -> `technical/software/security/EuCyberResilienceOverlay.sysml`
- `software/software-control-plane/SoftwareControlPlane.sysml` -> `technical/software/delivery-ops/SoftwareControlPlane.sysml`
- `software/software-delivery/SoftwareDelivery.sysml` -> `technical/software/delivery-ops/SoftwareDelivery.sysml`
- `software/observability-domain/ObservabilityDomain.sysml` -> `technical/software/delivery-ops/ObservabilityDomain.sysml`
- `software/cloud-runtime-domain/CloudRuntimeDomain.sysml` -> `technical/software/platform/CloudRuntimeDomain.sysml`
- `software/kubernetes-domain/KubernetesDomain.sysml` -> `technical/software/platform/KubernetesDomain.sysml`
- `software/sql-domain/SqlDomain.sysml` -> `technical/software/data/SqlDomain.sysml`
- `software/nosql-domain/NosqlDomain.sysml` -> `technical/software/data/NosqlDomain.sysml`

## Repository Standards

- Naming and severity conventions: `docs/conventions.md`.
- Rule-writing policy and model quality levels: `docs/conventions.md`.
- Cross-family examples and expected rule outcomes: see `examples/README.md`.
