package Translational {
    doc /*
     * One-dimensional translational components: a mass, a spring, a damper and a fixed
     * support. Each binds to the Modelica Standard Library class of the same kind, so a model
     * built from them simulates without any Modelica of its own. See `modelica/README.md`.
     */

    private import Elan8::Mechanical::Core::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import ISQ::*;
    private import Quantities::*;

    attribute def TranslationalStiffnessValue :> ScalarQuantityValue {
        doc /* Force per unit extension, for example 100 [N / m]. ISQ has no stiffness quantity. */
    }

    attribute def TranslationalDampingValue :> ScalarQuantityValue {
        doc /*
         * Force per unit velocity of a viscous damper, for example 4 [N * s / m]. Not ISQ's
         * DampingCoefficient, which is the 1/s decay rate of an oscillation.
         */
    }

    abstract part def TranslationalComponent :> MechanicalComponent {
        doc /* Two flanges. A positive force on a flange pushes its side towards the other. */
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
    }

    part def Mass :> TranslationalComponent {
        doc /*
         * A rigid body. `position` and `velocity` are the states of the simulation: give
         * their initial values with `:=` (`attribute :>> position := 0.1 [m];`), or the body
         * starts at 0 m, at rest.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Components.Mass";
            parameters = ("mass=m", "position=s", "velocity=v");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        attribute position : LengthValue;
        attribute velocity : SpeedValue;
    }

    part def Spring :> TranslationalComponent {
        doc /*
         * A linear spring. `unstretchedLength` is the distance between the two sides at which
         * it exerts no force.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Components.Spring";
            parameters = ("stiffness=c", "unstretchedLength=s_rel0");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        attribute stiffness : TranslationalStiffnessValue;
        attribute unstretchedLength : LengthValue;
    }

    part def Damper :> TranslationalComponent {
        doc /* A linear viscous damper: force proportional to the relative velocity of its sides. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Components.Damper";
            parameters = ("damping=d");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        attribute damping : TranslationalDampingValue;
    }

    part def FixedSupport :> MechanicalComponent {
        doc /* A support that does not move, at `position`. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Components.Fixed";
            parameters = ("position=s0");
            pins = ("side=flange");
        }
        attribute position : LengthValue;
        port side : TranslationalMechanicalPort;
    }
}
