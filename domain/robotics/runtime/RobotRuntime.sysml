package RobotRuntime {
    import RoboticsCore::*;
    import RobotControl::*;
    import RobotPerception::*;
    import CommunicationCore::*;

    attribute def ChannelType;
    attribute def LifecyclePhase;
    attribute def HealthState;

    part def RuntimeNode {
        attribute name : Name;
        ref controller : Controller;
        ref perceptionPipeline : PerceptionPipeline;
        ref healthMonitor : HealthMonitor;
        ref lifecycleState : LifecycleState;
    }

    part def ExecutionGraph {
        attribute name : Name;
        ref runtimeNode : RuntimeNode;
        ref runtimeChannel : RuntimeCommunicationChannel;
    }

    part def RuntimeCommunicationChannel :> CommunicationCore::CommunicationChannel {
        attribute name : Name;
        attribute channelType : ChannelType;
    }

    part def ParameterSet {
        attribute name : Name;
    }

    part def LifecycleState {
        attribute phase : LifecyclePhase;
    }

    part def HealthMonitor {
        attribute name : Name;
        attribute healthState : HealthState;
    }
}
