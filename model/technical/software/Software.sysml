package Software {
    package Core {
        private import Elan8::Core::*;
        private import ScalarValues::String;

        attribute def PathString { doc /* Name meant to be specialized. */ }
        attribute def VersionString { doc /* Name meant to be specialized. */ }
        attribute def EnvironmentName { doc /* Name meant to be specialized. */ }
        attribute def ResourceName { doc /* Name meant to be specialized. */ }
        attribute def CriticalityLevel { doc /* Name meant to be specialized. */ }
        attribute def OperationEffectKind { doc /* Name meant to be specialized. */ }
        attribute def LanguageName { doc /* Name meant to be specialized. */ }

        part def SoftwareComponent{
            attribute name : Name;
        }
        part def DeployableComponent :> SoftwareComponent;

        part def SourceArtifact :> SoftwareComponent {
            attribute artifactName : Name;
            attribute sourcePath : PathString;
            attribute languageName : LanguageName;
        }
        part def SourceFile :> SourceArtifact;

        part def ExecutableComponent :> DeployableComponent ;
        part def SoftwareModule :> SoftwareComponent {
            attribute moduleName : String;
        }
        part def SoftwareLibrary :> SoftwareComponent {
            attribute version : VersionString;
        }
        part def ExternalSystem :> SoftwareComponent {
            attribute systemName : String;
        }

        part def CapabilityRealization {
            attribute realizationName : Name;
            ref exposedCapability : OperationInterface;
            ref implementingComponent : SoftwareComponent;
            ref implementationArtifact : SourceArtifact;
        }

        abstract interface def SoftwareInterface;
        abstract interface def ApiInterface :> SoftwareInterface;
        abstract interface def AsyncInterface :> SoftwareInterface;
        abstract interface def OperationInterface :> SoftwareInterface {
            attribute effectKind : OperationEffectKind;
        }
        abstract interface def CommandInterface :> AsyncInterface, OperationInterface;
        abstract interface def QueryInterface :> ApiInterface, OperationInterface;
        abstract interface def AnalysisInterface :> ApiInterface, OperationInterface;
        abstract interface def MutatingInterface :> CommandInterface;

        item def DataType;
        item def MessageType :> DataType;

        part def ExecutionEnvironment {
            attribute runtimeName : Name;
            attribute runtimeVersion : VersionString;
        }

        part def DeploymentNode {
            attribute nodeName : String;
            attribute host : String;
        }

        part def Environment {
            attribute environmentName : EnvironmentName;
        }
    }
    public import Data;
    public import Distributed;
    public import Interactions;
    public import Platform;
    public import Realtime;
}
