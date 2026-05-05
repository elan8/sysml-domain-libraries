package MinimalRobotExample {
    import RoboticsCore::*;
    import RobotStructure::*;

    part robot : RobotSystem {
        attribute name = "inspection-rover";
    }

    part mission : MissionProfile {
        attribute name = "routine-inspection";
        attribute missionType = "inspection";
    }

    part environment : OperatingEnvironment {
        attribute name = "warehouse-floor";
        attribute environmentKind = "indoor";
    }

    part chassis : Chassis {
        attribute name = "base-chassis";
    }
}
