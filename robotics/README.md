# Modern Robotics Domain Libraries

This directory contains a SysML v2 domain-library family for modern robotics engineering.

It is organized as a self-contained workspace so it can evolve into:

- reusable library content
- example material
- a future Spec42 analysis fixture

## Structure

- `spec42.toml` - minimal workspace marker for Spec42-style analysis
- `robotics-core/RoboticsCore.sysml` - small robotics kernel with base system and environment concepts
- `robot-structure/RobotStructure.sysml` - neutral robot composition and hardware structure overlay
- `robot-perception/RobotPerception.sysml` - sensing and state-estimation overlay
- `robot-actuation/RobotActuation.sysml` - actuation and motion-production overlay
- `robot-control/RobotControl.sysml` - control-loop and command/feedback overlay
- `robot-autonomy/RobotAutonomy.sysml` - planning, navigation, localization, and behavior overlay
- `robot-runtime/RobotRuntime.sysml` - runtime execution, communication, parameters, and lifecycle overlay
- `robot-simulation/RobotSimulation.sysml` - simulation and hardware-in-the-loop overlay
- `robot-operations/RobotOperations.sysml` - fleet, telemetry, maintenance, and mission operations overlay
- `robot-safety-assurance/RobotSafetyAssurance.sysml` - hazards, safety functions, fail-safe behavior, and assurance overlay
- `ros2-overlay/Ros2Overlay.sysml` - ROS 2 middleware overlay built on the neutral robotics runtime
- `robotics-core/rules/robotics-core-rules.yaml` - core robotics rule catalog
- `robot-perception/rules/robot-perception-rules.yaml` - perception rule catalog
- `robot-control/rules/robot-control-rules.yaml` - control rule catalog
- `robot-runtime/rules/robot-runtime-rules.yaml` - runtime rule catalog
- `robot-safety-assurance/rules/robot-safety-assurance-rules.yaml` - safety and assurance rule catalog
- `ros2-overlay/rules/ros2-overlay-rules.yaml` - ROS 2 rule catalog
- `examples/inspection-rover/` - generic mobile robot example using neutral robotics packages
- `ros2-overlay/examples/inspection-rover-ros2/` - ROS 2-oriented refinement of the same robot class

## Notes

- The SysML files define reusable robotics concepts using ordinary package declarations and specialization.
- The YAML rule catalogs are descriptive metadata for future tooling and validation passes.
- Neutral robotics concepts stay separate from ROS 2-specific concepts so robots can be modeled with or without middleware commitments.
- Safety and assurance are explicit overlays rather than being folded into the robotics kernel.
- Future overlays can add ecosystem-specific content such as Nav2, MoveIt, Gazebo, industrial cells, or safety-standard mappings without restructuring the core packages.
