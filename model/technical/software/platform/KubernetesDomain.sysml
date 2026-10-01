package Kubernetes {
    private import Elan8::Core::Name;
    private import ScalarValues::String;
    private import Elan8::Communication::Core::PortNumber;
    private import Elan8::Software::Core::*;
    private import Elan8::Software::Distributed::*;

    attribute def ImageName;
    attribute def ReplicaCount;
    attribute def NamespaceName;

    part def KubernetesCluster :> DeploymentNode {
        attribute clusterName : String;
    }

    part def KubernetesNamespace {
        attribute namespaceName : NamespaceName;
    }

    part def KubernetesPod :> ServiceInstance {
        attribute image : ImageName;
    }

    part def KubernetesDeployment :> DeployableComponent {
        attribute deploymentName : Name;
        attribute replicas : ReplicaCount;
        attribute image : ImageName;
    }

    part def KubernetesService {
        attribute serviceName : Name;
        attribute portNumber : PortNumber;
    }
}
