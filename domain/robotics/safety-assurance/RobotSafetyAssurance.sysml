package RobotSafetyAssurance {
    import RoboticsCore::*;
    import RobotStructure::*;
    import RobotControl::*;
    import Elan8RequirementManagement::*;

    attribute def HazardSeverity;
    attribute def SafetyCategory;
    attribute def ConstraintType;

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
