package SoftwareControlPlane {
    import SoftwareCore::*;
    import DistributedSystems::*;

    attribute def ScalingTarget;
    attribute def HealthState;
    attribute def SliName;
    attribute def SloName;
    attribute def SafetyPolicyName;
    attribute def OutputPolicyName;
    attribute def ValidationName;

    part def ConfigurationSource {
        attribute sourceName : Name;
        attribute sourceUri : UriString;
    }

    part def ConfigurationItem {
        attribute key : Identifier;
    }

    part def SecretItem :> ConfigurationItem;

    part def ServiceDependencyLink :> ServiceDependency;

    part def RuntimeDependency {
        attribute dependencyName : Name;
    }

    part def ExternalToolDependency :> RuntimeDependency;

    part def IngressBoundary {
        attribute boundaryName : Name;
    }

    part def EgressBoundary {
        attribute boundaryName : Name;
    }

    part def PolicyBoundary {
        attribute boundaryName : Name;
    }

    part def HealthSignal {
        attribute signalName : Name;
        attribute healthState : HealthState;
    }

    part def ExecutionSafetyPolicy {
        attribute policyName : SafetyPolicyName;
    }

    part def PreviewPolicy :> ExecutionSafetyPolicy;
    part def ConfirmationPolicy :> ExecutionSafetyPolicy;
    part def ApplyPolicy :> ExecutionSafetyPolicy;

    part def ValidationStep {
        attribute validationName : ValidationName;
    }

    part def ExecutionFailureOutcome {
        attribute outcomeName : Name;
    }

    part def OutputHandlingPolicy {
        attribute policyName : OutputPolicyName;
    }

    part def BoundedOutputPolicy :> OutputHandlingPolicy;
    part def ExternalizedOutputPolicy :> OutputHandlingPolicy;

    part def ScalingPolicy {
        attribute target : ScalingTarget;
    }

    part def ArtifactReference {
        attribute artifactName : Name;
        attribute artifactUri : UriString;
        attribute version : VersionString;
    }

    part def ExternalEndpoint {
        attribute endpointName : Name;
        attribute endpointUri : UriString;
    }

    part def SliDefinition {
        attribute sliName : SliName;
    }

    part def SloDefinition {
        attribute sloName : SloName;
    }
}
