package Distributed {
    private import Elan8::Core::*;
    private import ScalarValues::String;
    private import Elan8::Software::Core::*;

    part def Service :> DeployableComponent {
        attribute serviceName : String;
    }

    part def ServiceInstance :> Service;
    part def Workload :> DeployableComponent {
        attribute workloadName : Name;
    }
    part def DomainBoundary {
        attribute boundaryName : Name;
    }
    part def ServiceDependency {
        attribute dependencyName : Name;
    }

    item def Event :> MessageType;
    item def Command :> MessageType;
    item def Query :> MessageType;

    part def Topic {
        attribute topicName : String;
    }

    part def Subscription;
    part def StreamChannel {
        attribute channelName : Name;
    }

    part def MessageBroker :> DeployableComponent;

    part def DataStore :> DeployableComponent {
        attribute storeName : String;
    }
}
