package Balancing {
    doc /*
     * A body balanced on one axle with two wheels, in the vertical plane: a wheeled inverted pendulum, as in a
     * self-balancing transporter. The vehicle, its rider and its cargo are one body described by their combined
     * mass, centre of mass and inertia; the wheels roll without slipping.
     */

    private import Elan8::Mechanical::Core::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import Elan8::Mechanical::Rotational::*;
    private import ISQ::*;
    private import Quantities::*;

    part def WheeledInvertedPendulum :> MechanicalComponent {
        doc /*
         * The motors connect to `drive`: a positive torque accelerates the wheels forward and exerts the opposite
         * torque on the body, which leans back. The system is unstable upright: left alone it falls with a time
         * constant of about 0.2 s for a standing person, so a controller has to keep it balanced. `pitch` is the
         * body's lean from the vertical, positive forward. Give the initial `position`, `velocity`, `pitch` and
         * `pitchRate` with `:=`. Everything is rest by default.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Elan8.Mechanical.WheeledInvertedPendulum";
            pins = ("drive=drive");
        }
        attribute bodyMass : MassValue;
        attribute bodyCenterHeight : LengthValue;
        attribute bodyInertia : MomentOfInertiaValue;
        attribute wheelMass : MassValue;
        attribute wheelInertia : MomentOfInertiaValue;
        attribute wheelRadius : LengthValue;
        attribute wheelDamping : RotationalDampingValue;
        attribute gravity : AccelerationValue;
        attribute position : LengthValue;
        attribute velocity : SpeedValue;
        attribute pitch : AngularMeasureValue;
        attribute pitchRate : AngularVelocityValue;
        port drive : RotationalMechanicalPort;
    }
}
