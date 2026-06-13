package ElectricalPowerDomain {
    import SoftwareCore::*;
    import ElectronicsCore::*;
    import ElectronicsInterconnection::*;

    attribute def VoltageValue;
    attribute def CurrentValue;
    attribute def PowerClass;
    attribute def EfficiencyClass;

    part def PowerRail :> ElectronicsComponent {
        attribute railName : Name;
        attribute voltage : VoltageValue;
        attribute currentBudget : CurrentValue;
        attribute powerClass : PowerClass;
        ref suppliedLoad : LoadGroup;
    }

    part def VoltageRegulator :> ElectronicsComponent {
        attribute regulatorName : Name;
        attribute efficiencyClass : EfficiencyClass;
        ref inputRail : PowerRail;
        ref outputRail : PowerRail;
    }

    part def DcDcConverter :> ElectronicsComponent {
        attribute converterName : Name;
        attribute efficiencyClass : EfficiencyClass;
    }

    part def LoadGroup {
        attribute loadName : Name;
        attribute currentBudget : CurrentValue;
        ref suppliedBy : PowerRail;
    }

    part def PowerDistributionNode :> ElectronicsComponent {
        attribute nodeName : Name;
        port railOut0 : PowerRailPort;
        port railOut1 : PowerRailPort;
        port railOut2 : PowerRailPort;
    }

    part def PowerLoadInterface :> ElectricalInterface;
}

