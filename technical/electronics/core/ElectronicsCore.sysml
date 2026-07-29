package ElectronicsCore {
    import Core::*;
    private import ISQ::*;

    attribute def SignalKind;
    attribute def VoltageClass;
    attribute def CurrentClass;
    attribute def TimingClass;
    attribute def PinCount;

    part def ElectronicsComponent :> PhysicalComponent {
        attribute powerDraw : PowerValue;
    }

    part def ElectricalInterface {
        attribute interfaceName : Name;
        attribute signalKind : SignalKind;
        attribute voltageClass : VoltageClass;
        attribute timingClass : TimingClass;
    }

    part def PinGroup {
        attribute groupName : Name;
        attribute pinCount : PinCount;
    }

    item def ElectricalSignal  {
        attribute signalName : Name;
        attribute signalKind : SignalKind;
    }
}
