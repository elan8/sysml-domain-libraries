# Robotics Business Domain Libraries

This directory contains a SysML v2 business-domain library family for robotics, composed from reusable technical and cross-cutting capabilities.

Use these packages when a model needs robotics vocabulary for robot structure, sensing, actuation, control, autonomy, runtime execution, simulation, operations, and safety assurance.

It is organized so it can evolve into:

- reusable library content
- example material
- a future Spec42 analysis fixture

## Best Starting Points

- Start with `robotics-core/RoboticsCore.sysml` for the base robot, environment, mission, and operating-context concepts.
- Add `structure/`, `perception/`, `actuation/`, and `control/` for core robot architecture.
- Add `autonomy/`, `runtime/`, `simulation/`, `operations/`, and `safety-assurance/` when the model needs richer lifecycle, operational, or assurance detail.
- For an end-to-end reference model, start with `examples/inspection-rover/inspection-rover.sysml`.

## Golden Path Composition

Use this import order when building a complete robotics model:

- `technical/systems-engineering/requirements/RequirementManagement.sysml` for stakeholder, system, safety, and verification coverage.
- `robotics-core/`, then `structure/`, `perception/`, `actuation/`, and `control/` for the robot architecture.
- `runtime/` and `safety-assurance/` for execution, health, hazards, mitigations, and evidence.
- `technical/electronics/` and `technical/communication/` for compute, power, channels, endpoints, and bindings.

Minimum golden path checklist:

- Model mission, environment, mode, and power context.
- Model sensing, state estimates, actuation command, feedback, and control loop.
- Model runtime node, health/lifecycle state, and communication channel.
- Model hazards, fail-safe behavior, safety function, evidence, and verification.
- Trace `UserRequirement` to `SystemRequirement` or `SafetyRequirement`, then `satisfy` and `verify` each active system requirement.

## Structure

- `robotics-core/RoboticsCore.sysml` - small robotics kernel with base system and environment concepts
- `structure/RobotStructure.sysml` - neutral robot composition and hardware structure overlay
- `perception/RobotPerception.sysml` - sensing and state-estimation overlay
- `actuation/RobotActuation.sysml` - actuation and motion-production overlay
- `control/RobotControl.sysml` - control-loop and command/feedback overlay
- `autonomy/RobotAutonomy.sysml` - planning, navigation, localization, and behavior overlay
- `runtime/RobotRuntime.sysml` - runtime execution, communication, parameters, and lifecycle overlay
- `simulation/RobotSimulation.sysml` - simulation and hardware-in-the-loop overlay
- `operations/RobotOperations.sysml` - fleet, telemetry, maintenance, and mission operations overlay
- `safety-assurance/RobotSafetyAssurance.sysml` - hazards, safety functions, fail-safe behavior, and assurance overlay
- `robotics-core/rules/robotics-core-rules.yaml` - core robotics rule catalog
- `perception/rules/robot-perception-rules.yaml` - perception rule catalog
- `control/rules/robot-control-rules.yaml` - control rule catalog
- `runtime/rules/robot-runtime-rules.yaml` - runtime rule catalog
- `safety-assurance/rules/robot-safety-assurance-rules.yaml` - safety and assurance rule catalog
- `examples/inspection-rover/inspection-rover.sysml` - end-to-end golden path reference model
- `examples/inspection-rover-missing-safety-verification/inspection-rover-missing-safety-verification.sysml` - intentionally incomplete safety verification example

## Notes

- The SysML files define reusable robotics concepts using ordinary package declarations and specialization.
- Naming is normalized around a primary `name` attribute in base definitions; examples override values instead of redefining schemas.
- Rule catalogs can be descriptive or executable and should stay focused on business-domain modeling quality.
- Safety and assurance are explicit overlays rather than being folded into the robotics kernel.
- Future overlays can add ecosystem-specific content without restructuring the core packages.

## Package Guidance

### robotics-core

- **When to use:** establish robot, mission, environment, and criticality baseline before adding overlays.
- **Anti-patterns:** starting with implementation overlays without a stable core vocabulary.
- **Minimum checklist:** robot system named, mission profile present, operating environment declared.

### structure, perception, actuation, control

- **When to use:** represent physical architecture and closed-loop sensing/actuation behavior.
- **Anti-patterns:** control loops defined without explicit feedback or actuator context.
- **Minimum checklist:** key subsystems identified, sensing and actuation paths visible, at least one control-loop concept mapped.

### autonomy and runtime

- **When to use:** model behavior planning, execution lifecycle, and runtime operating modes.
- **Anti-patterns:** autonomy intent modeled with no runtime ownership or execution context.
- **Minimum checklist:** autonomy role declared, runtime lifecycle state represented, operational mode captured.

### simulation and operations

- **When to use:** validate system behavior and represent fleet/mission operations.
- **Anti-patterns:** simulation model disconnected from mission or runtime assumptions.
- **Minimum checklist:** simulation purpose explicit, mission operations owner identified, telemetry responsibilities scoped.

### safety-assurance

- **When to use:** hazards, mitigations, safety functions, and assurance argumentation.
- **Anti-patterns:** safety claims without linked hazards or evidence-producing controls.
- **Minimum checklist:** hazards modeled, mitigation strategy represented, assurance responsibility identified.

## Rules And Quality

- Rule catalogs live in each package `rules/` directory.
- Severity interpretation and naming standards are defined in `docs/conventions.md`.
- Use warning-level rules for early model shaping and error-level gates for release-readiness checks.
