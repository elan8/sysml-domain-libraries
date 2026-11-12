package Dynamics {
    doc /*
     * Rigid-body parts with a Modelica constitutive model. The rotational
     * flange fixes the hinge axis; it is not the swing angle.
     */

    private import Elan8::Mechanical::Core::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import Elan8::PhysicalModeling::*;
    private import ISQ::*;

    part def InertialFrame :> MechanicalComponent {
        doc /* Hinge axis held at angle 0 in the lab. */
        port flange : RotationalMechanicalPort;
        @ModelicaModel {
            resourceUri = "modelica/Elan8Mechanics.mo";
            className = "Elan8Mechanics.InertialFrame";
        }
    }

    part def Pendulum :> MechanicalComponent {
        doc /*
         * Point mass on a frictionless hinge. `releaseAngle` is the angle
         * from the downward vertical at rest, with zero angular velocity.
         * Gravity, length, and mass are attributes of the part; none is
         * filled in by the simulator.
         */
        attribute mass : MassValue;
        attribute length : LengthValue;
        attribute gravity : AccelerationValue;
        attribute releaseAngle : AngularMeasureValue;
        port pivot : RotationalMechanicalPort;
        @ModelicaModel {
            resourceUri = "modelica/Elan8Mechanics.mo";
            className = "Elan8Mechanics.Pendulum";
        }
    }
}
