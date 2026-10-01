package Composition {
    private import Elan8::Mechanical::Drivetrain::*;
    private import Elan8::Mechanical::Core::*;
    private import ISQ::*;
    private import SI::*;
    private import MeasurementReferences::one;
    private import QuantityCalculations::sum;

    part def SampleDriveTrainAssembly :> MechanicalComponent {
        part gearbox : Gearbox {
            attribute :>> gearRatio = 30 [one];
            attribute :>> mass = 0.15 [kg];
        }
        part wheel : Wheel {
            attribute :>> diameter = 65 [mm];
            attribute :>> mass = 0.08 [kg];
        }
        part caster : CasterWheel {
            attribute :>> mass = 0.03 [kg];
        }
        attribute :>> mass = sum((gearbox.mass, wheel.mass, caster.mass));
    }
}
