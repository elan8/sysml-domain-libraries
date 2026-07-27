package InspectionRoverMissingSafetyVerificationExample {
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
        @StatusInfo { status = done; }
        doc /* Operators shall be able to run routine autonomous warehouse inspections. */
    }

    requirement stopForObstacles {
        @StatusInfo { status = done; }
        doc /* The inspection rover shall enter controlled stop when an obstacle is detected in its path. */
    }

    #derivation connection {
        end #original ::> inspectWarehouse;
        end #derive ::> stopForObstacles;
    }

    satisfy stopForObstacles by obstacleStopFunction;
}
