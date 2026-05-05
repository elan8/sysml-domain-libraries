package SoftwareCore {
    attribute def Identifier;
    attribute def Name;
    attribute def Hostname;
    attribute def PathString;
    attribute def PortNumber;
    attribute def ProtocolName;
    attribute def UriString;
    attribute def VersionString;
    attribute def EnvironmentName;
    attribute def ResourceName;
    attribute def CriticalityLevel;
    attribute def OperationEffectKind;
    attribute def LanguageName;

    part def SoftwareComponent;
    part def DeployableComponent :> SoftwareComponent;
    part def SourceArtifact :> SoftwareComponent {
        attribute artifactName : Name;
        attribute sourcePath : PathString;
        attribute languageName : LanguageName;
    }
    part def SourceFile :> SourceArtifact;
    part def SoftwareModule :> SoftwareComponent {
        attribute moduleName : Name;
    }
    part def ExecutableComponent :> DeployableComponent {
        attribute executableName : Name;
    }
    part def SoftwareLibrary :> SoftwareComponent {
        attribute libraryName : Name;
        attribute version : VersionString;
    }
    part def ExternalSystem :> SoftwareComponent {
        attribute systemName : Name;
    }

    part def CapabilityRealization {
        attribute realizationName : Name;
        ref exposedCapability : OperationInterface;
        ref implementingComponent : SoftwareComponent;
        ref implementationArtifact : SourceArtifact;
    }

    interface def SoftwareInterface;
    interface def ApiInterface :> SoftwareInterface;
    interface def AsyncInterface :> SoftwareInterface;
    interface def OperationInterface :> SoftwareInterface {
        attribute effectKind : OperationEffectKind;
    }
    interface def CommandInterface :> AsyncInterface, OperationInterface;
    interface def QueryInterface :> ApiInterface, OperationInterface;
    interface def AnalysisInterface :> ApiInterface, OperationInterface;
    interface def MutatingInterface :> CommandInterface;

    item def DataType;
    item def MessageType :> DataType;

    part def ExecutionEnvironment {
        attribute runtimeName : Name;
        attribute runtimeVersion : VersionString;
    }

    part def DeploymentNode {
        attribute nodeName : Name;
        attribute host : Hostname;
    }

    part def Environment {
        attribute environmentName : EnvironmentName;
    }
}
