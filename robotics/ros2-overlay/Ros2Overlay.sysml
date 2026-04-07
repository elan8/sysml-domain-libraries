package Ros2Overlay {
    import RoboticsCore::*;
    import RobotRuntime::*;

    attribute def TopicName;
    attribute def ServiceName;
    attribute def ActionName;
    attribute def ParameterName;
    attribute def PackageName;
    attribute def FrameName;

    part def RosNode specializes RuntimeNode;

    part def RosTopic {
        attribute topicName : TopicName;
    }

    part def RosPublisher {
        attribute publisherName : Name;
    }

    part def RosSubscriber {
        attribute subscriberName : Name;
    }

    part def RosService {
        attribute serviceName : ServiceName;
    }

    part def RosClient {
        attribute clientName : Name;
    }

    part def RosActionServer {
        attribute actionName : ActionName;
    }

    part def RosActionClient {
        attribute actionName : ActionName;
    }

    part def RosParameter {
        attribute parameterName : ParameterName;
    }

    part def RosLifecycleNode specializes RosNode;

    item def RosMessageType {
        attribute messageName : Name;
    }

    part def RosPackage {
        attribute packageName : PackageName;
    }

    part def RosLaunchDescription {
        attribute launchName : Name;
    }

    part def RosTransformFrame {
        attribute frameName : FrameName;
    }
}
