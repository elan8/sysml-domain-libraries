package Rotational {
    doc /*
     * One-dimensional rotational components: an inertia, a torsional spring and damper, a fixed
     * support and a constant torque source. Each binds to the Modelica Standard Library class of
     * the same kind, so a model built from them simulates without Modelica of its own. A
     * `Gearbox` and a `RollingWheel` are in `Elan8::Mechanical::Drivetrain`.
     */

    private import Elan8::Mechanical::Core::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import ISQ::*;
    private import Quantities::*;

    attribute def RotationalStiffnessValue :> ScalarQuantityValue {
        doc /* Torque per unit twist, for example 1 [N * m / rad]. */
    }

    attribute def RotationalDampingValue :> ScalarQuantityValue {
        doc /* Torque per unit angular velocity of a viscous damper, for example 0.04 [N * m * s / rad]. */
    }

    abstract part def RotationalComponent :> MechanicalComponent {
        doc /* Two flanges, side A and side B. */
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
    }

    part def Inertia :> RotationalComponent {
        doc /*
         * A rigid rotor. `angle` and `angularVelocity` are its states: give their initial values
         * with `:=`, or it starts at 0 rad, at rest.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.Inertia";
            parameters = ("inertia=J", "angle=phi", "angularVelocity=w");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        attribute inertia : MomentOfInertiaValue;
        attribute angle : AngularMeasureValue;
        attribute angularVelocity : AngularVelocityValue;
    }

    part def TorsionalSpring :> RotationalComponent {
        doc /* A linear torsional spring. `unstretchedAngle` is the twist at which it exerts no torque. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.Spring";
            parameters = ("stiffness=c", "unstretchedAngle=phi_rel0");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        attribute stiffness : RotationalStiffnessValue;
        attribute unstretchedAngle : AngularMeasureValue;
    }

    part def TorsionalDamper :> RotationalComponent {
        doc /* A linear viscous damper: torque proportional to the relative angular velocity of its sides. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.Damper";
            parameters = ("damping=d");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        attribute damping : RotationalDampingValue;
    }

    part def RotationalFixedSupport :> MechanicalComponent {
        doc /* A support that does not rotate, at `angle`. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.Fixed";
            parameters = ("angle=phi0");
            pins = ("side=flange");
        }
        attribute angle : AngularMeasureValue;
        port side : RotationalMechanicalPort;
    }

    part def TorqueSource :> MechanicalComponent {
        doc /* A constant torque, independent of speed. A positive torque accelerates the connected side in the positive direction. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.ConstantTorque";
            parameters = ("torque=tau_constant");
            pins = ("side=flange");
        }
        attribute torque : TorqueValue;
        port side : RotationalMechanicalPort;
    }
}
