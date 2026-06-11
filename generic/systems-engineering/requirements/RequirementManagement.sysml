package RequirementManagement {
    attribute def Identifier;
    attribute def Name;
    attribute def BaselineName;
    attribute def EvidenceUri;
    attribute def VerificationMethod;
    attribute def VerificationVerdict;
    attribute def TraceabilityConcernKind;

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
        ref includedRequirement;
    }

    part def TraceabilityConcern {
        attribute concernName : Name;
        attribute concernKind : TraceabilityConcernKind;
        ref sourceRequirement;
        ref targetRequirement;
    }
}
