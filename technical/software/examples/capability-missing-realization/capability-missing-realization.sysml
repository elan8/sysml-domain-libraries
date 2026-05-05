package CapabilityMissingRealizationExample {
    import SoftwareCore::*;

    part automationService : SoftwareComponent;

    interface exposedWorkspaceInsight : QueryInterface {
        attribute :>> effectKind = "read-only";
    }
}
