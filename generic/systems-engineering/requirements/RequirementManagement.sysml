package RequirementManagement {
    attribute def Identifier;
    attribute def Name;
    attribute def BaselineName;
    attribute def EvidenceUri;
    attribute def VerificationMethod;
    attribute def VerificationVerdict;
    attribute def TraceabilityConcernKind;

    enum def RequirementStatusKind {
        enum draft;
        enum proposed;
        enum approved;
        enum rejected;
        enum obsolete;
    }

    requirement def ManagedRequirement specializes Requirements::RequirementCheck {
        attribute requirementId : Identifier;
        attribute status : RequirementStatusKind;
    }

    requirement def StakeholderRequirement :> ManagedRequirement;
    requirement def UserRequirement :> StakeholderRequirement;
    requirement def SystemRequirement :> ManagedRequirement;
    requirement def FunctionalRequirement :> SystemRequirement;
    requirement def PerformanceRequirement :> SystemRequirement;
    requirement def InterfaceRequirement :> SystemRequirement;
    requirement def SafetyRequirement :> SystemRequirement;
    requirement def SecurityRequirement :> SystemRequirement;
    requirement def RegulatoryRequirement :> SystemRequirement;

    verification def VerificationCase {
        attribute caseName : Name;
        attribute method : VerificationMethod;
    }

    part def VerificationEvidence {
        attribute evidenceName : Name;
        attribute evidenceUri : EvidenceUri;
    }

    part def VerificationResult {
        attribute resultName : Name;
        attribute verdict : VerificationVerdict;
        ref evidence : VerificationEvidence;
    }

    part def RequirementBaseline {
        attribute baselineName : BaselineName;
        ref includedRequirement : ManagedRequirement;
    }

    part def TraceabilityConcern {
        attribute concernName : Name;
        attribute concernKind : TraceabilityConcernKind;
        ref sourceRequirement : ManagedRequirement;
        ref targetRequirement : ManagedRequirement;
    }
}
