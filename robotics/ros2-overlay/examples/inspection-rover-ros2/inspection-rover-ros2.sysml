package InspectionRoverRos2Example {
    import RoboticsCore::*;
    import RobotStructure::*;
    import RobotPerception::*;
    import RobotActuation::*;
    import RobotControl::*;
    import RobotAutonomy::*;
    import RobotRuntime::*;
    import RobotSafetyAssurance::*;
    import Ros2Overlay::*;

    part def InspectionRover specializes RobotPlatform {
        attribute robotName = "inspection-rover";
        attribute criticality = "medium";
    }

    part def LidarNode specializes RosLifecycleNode {
        attribute nodeName = "lidar_node";
    }

    part def LocalizationNode specializes RosLifecycleNode {
        attribute nodeName = "localization_node";
    }

    part def NavigationNode specializes RosNode {
        attribute nodeName = "navigation_node";
    }

    part def CmdVelTopic specializes RosTopic {
        attribute topicName = "/cmd_vel";
    }

    part def ScanTopic specializes RosTopic {
        attribute topicName = "/scan";
    }

    part def TfTopic specializes RosTopic {
        attribute topicName = "/tf";
    }

    part def CmdVelPublisher specializes RosPublisher {
        attribute publisherName = "nav-cmd-vel-publisher";
    }

    part def ScanSubscriber specializes RosSubscriber {
        attribute subscriberName = "localization-scan-subscriber";
    }

    part def NavigateActionServer specializes RosActionServer {
        attribute actionName = "navigate_to_pose";
    }

    part def CostmapParameters specializes RosParameter {
        attribute parameterName = "local_costmap";
    }

    item def TwistMessage specializes RosMessageType {
        attribute messageName = "geometry_msgs/Twist";
    }

    item def LaserScanMessage specializes RosMessageType {
        attribute messageName = "sensor_msgs/LaserScan";
    }

    part def RoverPackage specializes RosPackage {
        attribute packageName = "inspection_rover_bringup";
    }

    part def RoverLaunch specializes RosLaunchDescription {
        attribute launchName = "inspection_rover.launch.py";
    }

    part def BaseLinkFrame specializes RosTransformFrame {
        attribute frameName = "base_link";
    }

    part def OdomFrame specializes RosTransformFrame {
        attribute frameName = "odom";
    }

    part def RoverLifecycle specializes LifecycleState {
        attribute phase = "active";
    }

    part def RoverHealth specializes HealthMonitor {
        attribute monitorName = "ros2-runtime-health";
        attribute healthState = "ready";
    }

    part def DifferentialDrive specializes DriveTrain {
        attribute driveName = "differential-drive";
    }

    part def FrontLidar specializes LidarSensor {
        attribute sensorName = "front-lidar";
        attribute sensorType = "lidar";
    }

    part def VelocityControl specializes ControlLoop {
        attribute loopName = "velocity-control";
        attribute controlType = "closed-loop";
    }

    part def CollisionHazard specializes Hazard {
        attribute hazardName = "collision-with-obstacle";
        attribute severity = "high";
    }

    part def EmergencyStop specializes SafetyFunction {
        attribute functionName = "emergency-stop";
        attribute category = "protective-stop";
    }
}
