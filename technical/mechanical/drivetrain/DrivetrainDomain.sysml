package DrivetrainDomain {
    private import MechanicalCore::*;
    private import MechanicalInterconnection::*;
    private import ISQ::*;
    private import MeasurementReferences::*;

    part def Gearbox :> MechanicalComponent {
        attribute gearRatio : DimensionOneValue;
        port rotationalInput : RotationalMechanicalPort;
        port rotationalOutput : RotationalMechanicalPort;
    }

    part def Wheel :> MechanicalComponent {
        attribute diameter : LengthValue;
        port axle : RotationalMechanicalPort;
    }

    part def CasterWheel :> MechanicalComponent;
}
