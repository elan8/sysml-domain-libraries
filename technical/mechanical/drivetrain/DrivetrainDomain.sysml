package DrivetrainDomain {
    private import MechanicalCore::*;
    private import ISQ::*;
    private import MeasurementReferences::*;

    part def Gearbox :> MechanicalComponent {
        attribute gearRatio : DimensionOneValue;
    }

    part def Wheel :> MechanicalComponent {
        attribute diameter : LengthValue;
    }

    part def CasterWheel :> MechanicalComponent;
}
