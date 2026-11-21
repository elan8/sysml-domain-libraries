package Drivetrain {
    private import Elan8::Mechanical::Core::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import ISQ::*;
    private import MeasurementReferences::*;

    part def Gearbox :> MechanicalComponent {
        doc /*
         * An ideal gearbox. `gearRatio` is the input angle divided by the output angle: a ratio
         * of 10 turns the output once for ten turns of the input and multiplies the torque by 10.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.IdealGear";
            parameters = ("gearRatio=ratio");
            pins = ("rotationalInput=flange_a", "rotationalOutput=flange_b");
        }
        attribute gearRatio : DimensionOneValue;
        port rotationalInput : RotationalMechanicalPort;
        port rotationalOutput : RotationalMechanicalPort;
    }

    part def Wheel :> MechanicalComponent {
        attribute diameter : LengthValue;
        port axle : RotationalMechanicalPort;
    }

    part def RollingWheel :> Wheel {
        doc /*
         * A wheel that rolls without slipping: the axle turns by an angle and the contact
         * point moves by `radius` times that angle. A simulation uses `radius`, not the
         * inherited `diameter`, so give `radius`.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.IdealRollingWheel";
            pins = ("axle=flangeR", "contact=flangeT");
        }
        attribute radius : LengthValue;
        port contact : TranslationalMechanicalPort;
    }

    part def CasterWheel :> MechanicalComponent;
}
