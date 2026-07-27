package RobotSafetyAssurance {
    import RoboticsCore::*;
    import RobotStructure::*;
    import RobotControl::*;

    attribute def HazardSeverity;
    attribute def SafetyCategory;
    attribute def ConstraintType;
    attribute def EvidenceUri;

    part def VerificationEvidence {
        doc /* Domain-local reference to external verification evidence (URI/name). Not an Elan8 Method package. */
        attribute evidenceName : Name;
        attribute evidenceUri : EvidenceUri;
    }

    part def Hazard {
        attribute hazardName : Name;
        attribute severity : HazardSeverity;
    }

    part def SafetyFunction {
        attribute functionName : Name;
        attribute category : SafetyCategory;
        ref mitigatedHazard : Hazard;
        ref implementedBy : RiskControl;
        ref evidence : VerificationEvidence;
    }

    part def SafetyBoundary {
        attribute boundaryName : Name;
    }

    part def RiskControl {
        attribute controlName : Name;
        ref mitigatedHazard : Hazard;
        ref failSafeMode : FailSafeMode;
    }

    part def FailSafeMode {
        attribute modeName : ModeName;
    }

    part def SafetyCase {
        attribute caseName : Name;
        ref claim : SafetyFunction;
        ref evidence : VerificationEvidence;
    }

    part def OperationalConstraint {
        attribute constraintName : Name;
        attribute constraintType : ConstraintType;
    }
}
