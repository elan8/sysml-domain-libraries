package InspectionRoverExample {
    import RoboticsCore::*;
    import RobotStructure::*;
    import RobotPerception::*;
    import RobotActuation::*;
    import RobotControl::*;
    import RobotAutonomy::*;
    import RobotRuntime::*;
    import RobotSafetyAssurance::*;

    part def InspectionRover specializes RobotPlatform {
        attribute robotName = "inspection-rover";
        attribute criticality = "medium";
    }

    part def PatrolMission specializes MissionProfile {
        attribute missionName = "facility-inspection";
        attribute missionType = "inspection";
    }

    part def WarehouseEnvironment specializes OperatingEnvironment {
        attribute environmentName = "warehouse-floor";
        attribute environmentKind = "indoor-industrial";
    }

    part def DifferentialDrive specializes DriveTrain {
        attribute driveName = "differential-drive";
    }

    part def WheelMotorController specializes MotorController {
        attribute controllerName = "wheel-motor-controller";
    }

    part def FrontLidar specializes LidarSensor {
        attribute sensorName = "front-lidar";
        attribute sensorType = "lidar";
    }

    part def BodyImu specializes ImuSensor {
        attribute sensorName = "body-imu";
        attribute sensorType = "imu";
    }

    part def OdometryEstimate specializes StateEstimate {
        attribute estimateName = "odometry";
        attribute estimateType = "pose";
    }

    part def VelocityControl specializes ControlLoop {
        attribute loopName = "velocity-control";
        attribute controlType = "closed-loop";
    }

    part def VelocityCommand specializes MotionCommand {
        attribute commandName = "cmd-vel";
        attribute commandType = "twist";
    }

    part def WheelFeedback specializes FeedbackSignal {
        attribute signalName = "wheel-encoder-feedback";
        attribute feedbackKind = "encoder";
    }

    part def NavigationBehavior specializes NavigationFunction {
        attribute behaviorName = "waypoint-navigation";
    }

    part def LocalizationBehavior specializes LocalizationFunction {
        attribute behaviorName = "localization";
    }

    part def RoverRuntime specializes RuntimeNode {
        attribute nodeName = "rover-runtime";
    }

    part def RoverHealth specializes HealthMonitor {
        attribute monitorName = "base-health";
        attribute healthState = "ready";
    }

    part def CollisionHazard specializes Hazard {
        attribute hazardName = "collision-with-obstacle";
        attribute severity = "high";
    }

    part def EmergencyStop specializes SafetyFunction {
        attribute functionName = "emergency-stop";
        attribute category = "protective-stop";
    }

    part def StopMode specializes FailSafeMode {
        attribute modeName = "halt";
    }
}
