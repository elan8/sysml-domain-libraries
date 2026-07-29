package Elan8 {
    package Software {
        package Platform {
            package Kubernetes {
                private import Elan8::Core::Name;
                private import Elan8::Communication::Core::PortNumber;
                import Elan8::Software::Core::*;
                import Elan8::Software::Distributed::*;

                attribute def ImageName;
                attribute def ReplicaCount;
                attribute def NamespaceName;

                part def KubernetesCluster :> DeploymentNode {
                    attribute clusterName : Name;
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
                    attribute port : PortNumber;
                }
            }
        }
    }
}
