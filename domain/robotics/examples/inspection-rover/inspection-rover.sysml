package InspectionRoverExample {
    import Elan8RequirementManagement::*;
    import Elan8RequirementMetadata::*;
    import ModelingMetadata::*;
    import RoboticsCore::*;
    import RobotStructure::*;
    import RobotPerception::*;
    import RobotActuation::*;
    import RobotControl::*;
    import RobotRuntime::*;
    import RobotSafetyAssurance::*;
    import ElectronicsCore::*;
    import ElectricalPowerDomain::*;
    import EmbeddedComputeDomain::*;
    import CommunicationCore::*;
    import SoftwareCore::*;

    part inspectionMission : MissionProfile {
        attribute :>> name = "warehouse-inspection";
        attribute :>> missionType = "routine-inspection";
    }

    part warehouseFloor : OperatingEnvironment {
        attribute :>> name = "warehouse-floor";
        attribute :>> environmentKind = "indoor-shared-space";
    }

    part patrolMode : RobotMode {
        attribute :>> modeName = "autonomous-patrol";
    }

    part batteryPack : PowerSource {
        attribute :>> name = "battery-pack";
        attribute :>> powerKind = "rechargeable-battery";
    }

    part rover : RobotPlatform {
        attribute :>> name = "inspection-rover";
        attribute :>> criticality = "safety-relevant";
        ref missionProfile : MissionProfile;
        ref environmentContext : OperatingEnvironment;
        ref modeContext : RobotMode;
        ref batteryContext : PowerSource;
    }

    part chassis : Chassis {
        attribute :>> name = "differential-drive-chassis";
    }

    part camera : CameraSensor {
        attribute :>> name = "front-camera";
        attribute :>> sensorType = "rgb-camera";
    }

    part lidar : LidarSensor {
        attribute :>> name = "safety-lidar";
        attribute :>> sensorType = "two-dimensional-lidar";
    }

    part obstacleEstimate : StateEstimate {
        attribute :>> name = "obstacle-field-estimate";
        attribute :>> estimateType = "obstacle-proximity";
    }

    part obstaclePipeline : PerceptionPipeline {
        attribute :>> name = "obstacle-perception";
        ref lidarInput : Sensor;
        ref obstacleOutput : StateEstimate;
    }

    part wheelDrive : DriveTrain {
        attribute :>> name = "differential-wheel-drive";
        ref driveActuator : Actuator;
    }

    part wheelMotor : ServoActuator {
        attribute :>> name = "wheel-servo";
        attribute :>> actuatorType = "drive-servo";
    }

    part velocityCommand : MotionCommand {
        attribute :>> name = "velocity-command";
        attribute :>> commandType = "linear-angular-velocity";
        ref commandedActuator : Actuator;
    }

    part velocityFeedback : FeedbackSignal {
        attribute :>> name = "wheel-velocity-feedback";
        attribute :>> feedbackKind = "encoder-velocity";
    }

    part targetVelocity : Setpoint {
        attribute :>> name = "target-velocity";
    }

    part driveController : TrajectoryController {
        attribute :>> name = "drive-controller";
    }

    part driveLoop : ControlLoop {
        attribute :>> name = "closed-loop-drive-control";
        attribute :>> controlType = "velocity-control";
        ref driveControlFunction : Controller;
        ref driveCommand : ActuationCommand;
        ref driveFeedback : FeedbackSignal;
        ref driveTarget : Setpoint;
        ref driveActuator : Actuator;
    }

    part computePowerRail : PowerRail {
        attribute :>> componentName = "logic-power-rail";
        attribute :>> railName = "5v-logic";
        attribute :>> voltage = "5V";
        attribute :>> currentBudget = "3A";
        attribute :>> powerClass = "low-voltage-dc";
    }

    part motionControllerBoard : Microcontroller {
        attribute :>> componentName = "motion-controller-board";
        attribute :>> unitName = "motion-mcu";
        attribute :>> computeClass = "realtime-control";
        ref firmware : FirmwareImageSlot;
        ref supplyRail : PowerRail;
    }

    part controlFirmware : FirmwareImageSlot {
        attribute :>> slotName = "control-firmware";
        attribute :>> version = "1.0.0";
    }

    part telemetryEndpoint : CommunicationEndpoint {
        attribute :>> protocol = "mqtt";
        attribute :>> path = "inspection-rover/telemetry";
        attribute :>> port = 1883;
    }

    part telemetryChannel : RuntimeCommunicationChannel {
        attribute :>> channelName = "rover-telemetry";
        attribute :>> name = "rover-telemetry-runtime-channel";
        attribute :>> channelType = "telemetry";
    }

    part telemetryBinding : CommunicationBinding {
        attribute :>> bindingName = "runtime-telemetry-binding";
        ref runtimeEndpoint : CommunicationEndpoint;
        ref runtimeChannel : CommunicationCore::CommunicationChannel;
    }

    part runtimeHealth : HealthMonitor {
        attribute :>> name = "runtime-health";
        attribute :>> healthState = "healthy";
    }

    part runtimeLifecycle : LifecycleState {
        attribute :>> phase = "operational";
    }

    part roverRuntime : RuntimeNode {
        attribute :>> name = "rover-runtime-node";
        ref executedController : Controller;
        ref executedPerception : PerceptionPipeline;
        ref runtimeHealthMonitor : HealthMonitor;
        ref runtimeState : LifecycleState;
    }

    part roverExecution : ExecutionGraph {
        attribute :>> name = "inspection-rover-execution";
        ref executionNode : RuntimeNode;
        ref executionChannel : RuntimeCommunicationChannel;
    }

    part obstacleCollisionHazard : Hazard {
        attribute :>> hazardName = "collision-with-obstacle";
        attribute :>> severity = "major";
    }

    part controlledStopMode : FailSafeMode {
        attribute :>> modeName = "controlled-stop";
    }

    part stopRiskControl : RiskControl {
        attribute :>> controlName = "stop-before-obstacle";
        ref hazard : Hazard;
        ref failSafe : FailSafeMode;
    }

    part stopEvidence : VerificationEvidence {
        attribute :>> evidenceName = "obstacle-stop-test-report";
        attribute :>> evidenceUri = "evidence://inspection-rover/obstacle-stop";
    }

    part obstacleStopFunction : SafetyFunction {
        attribute :>> functionName = "obstacle-stop";
        attribute :>> category = "collision-avoidance";
        ref hazard : Hazard;
        ref control : RiskControl;
        ref testEvidence : VerificationEvidence;
    }

    requirement inspectWarehouse {
        @RequirementRole { role = user; }
        @RequirementIdentity { requirementId = "USR-IR-001"; }
        @StatusInfo { status = done; }
        doc /* Operators shall be able to run routine autonomous warehouse inspections. */
    }

    requirement patrolAisles {
        @RequirementRole { role = functional; }
        @RequirementIdentity { requirementId = "SYS-IR-001"; }
        @StatusInfo { status = done; }
        doc /* The inspection rover shall patrol warehouse aisles in autonomous patrol mode. */
    }

    requirement reportTelemetry {
        @RequirementRole { role = performance; }
        @RequirementIdentity { requirementId = "SYS-IR-002"; }
        @StatusInfo { status = done; }
        doc /* The inspection rover shall report runtime telemetry during patrol operations. */
    }

    requirement stopForObstacles {
        @RequirementRole { role = safety; }
        @RequirementIdentity { requirementId = "SYS-IR-003"; }
        @StatusInfo { status = done; }
        doc /* The inspection rover shall enter controlled stop when an obstacle is detected in its path. */
    }

    #derivation connection {
        end #original ::> inspectWarehouse;
        end #derive ::> patrolAisles;
    }

    #derivation connection {
        end #original ::> inspectWarehouse;
        end #derive ::> reportTelemetry;
    }

    #derivation connection {
        end #original ::> inspectWarehouse;
        end #derive ::> stopForObstacles;
    }

    satisfy patrolAisles by rover;
    satisfy reportTelemetry by telemetryChannel;
    satisfy stopForObstacles by obstacleStopFunction;

    verification verifyPatrolCoverage {
        subject systemUnderTest : RobotPlatform;
        objective {
            verify patrolAisles;
        }
    }

    verification verifyTelemetryReporting {
        subject systemUnderTest : RuntimeCommunicationChannel;
        objective {
            verify reportTelemetry;
        }
    }

    verification verifyObstacleStop {
        subject systemUnderTest : SafetyFunction;
        objective {
            verify stopForObstacles;
        }
    }
}
