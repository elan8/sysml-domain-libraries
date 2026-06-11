package InspectionRoverMissingSafetyVerificationExample {
    import RequirementManagement::*;
    import RequirementMetadata::*;
    import ModelingMetadata::*;
    import RoboticsCore::*;
    import RobotStructure::*;
    import RobotSafetyAssurance::*;

    part rover : RobotPlatform {
        attribute :>> name = "inspection-rover";
        attribute :>> criticality = "safety-relevant";
    }

    part obstacleCollisionHazard : Hazard {
        attribute :>> hazardName = "collision-with-obstacle";
        attribute :>> severity = "major";
    }

    part controlledStopMode : FailSafeMode {
        attribute :>> modeName = "controlled-stop";
    }

    part stopRiskControl : RiskControl {
        attribute :>> controlName = "stop-before-obstacle";
    }

    part obstacleStopFunction : SafetyFunction {
        attribute :>> functionName = "obstacle-stop";
        attribute :>> category = "collision-avoidance";
    }

    requirement inspectWarehouse {
        @RequirementRole { role = user; }
        @RequirementIdentity { requirementId = "USR-IR-101"; }
        @StatusInfo { status = done; }
        doc /* Operators shall be able to run routine autonomous warehouse inspections. */
    }

    requirement stopForObstacles {
        @RequirementRole { role = safety; }
        @RequirementIdentity { requirementId = "SYS-IR-103"; }
        @StatusInfo { status = done; }
        doc /* The inspection rover shall enter controlled stop when an obstacle is detected in its path. */
    }

    #derivation connection {
        end #original ::> inspectWarehouse;
        end #derive ::> stopForObstacles;
    }

    satisfy stopForObstacles by obstacleStopFunction;
}
