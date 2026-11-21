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

    // BEGIN GENERATED MECHANICS BINDINGS
    port def ForceSignalPort {
        out attribute force : ForceValue;
    }

    port def LinearAccelerationSignalPort {
        out attribute acceleration : AccelerationValue;
    }

    port def LinearPositionSignalPort {
        out attribute position : LengthValue;
    }

    port def LinearVelocitySignalPort {
        out attribute velocity : SpeedValue;
    }

    part def ConstantForceSource :> MechanicalComponent {
        doc /* Applies a constant force. Positive force accelerates the connected side in the positive direction. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.ConstantForce";
            parameters = ("force=f_constant");
            pins = ("side=flange");
        }
        port side : TranslationalMechanicalPort;
        attribute force : ForceValue;
    }

    part def StepForceSource :> MechanicalComponent {
        doc /* Applies initialForce before stepTime, then initialForce plus stepHeight. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.ForceStep";
            parameters = ("initialForce=offsetForce", "stepHeight=stepForce", "stepTime=startTime");
            pins = ("side=flange");
        }
        port side : TranslationalMechanicalPort;
        attribute initialForce : ForceValue;
        attribute stepHeight : ForceValue;
        attribute stepTime : DurationValue;
    }

    part def LinearPositionSensor :> MechanicalComponent {
        doc /* Measures absolute position without exerting force. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.PositionSensor";
            pins = ("side=flange", "signal=s");
        }
        port side : TranslationalMechanicalPort;
        port signal : LinearPositionSignalPort;
        attribute s : LengthValue;
    }

    part def LinearSpeedSensor :> MechanicalComponent {
        doc /* Measures absolute velocity without exerting force. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.SpeedSensor";
            pins = ("side=flange", "signal=v");
        }
        port side : TranslationalMechanicalPort;
        port signal : LinearVelocitySignalPort;
        attribute v : SpeedValue;
    }

    part def LinearAccelerationSensor :> MechanicalComponent {
        doc /* Measures absolute acceleration without exerting force. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.AccSensor";
            pins = ("side=flange", "signal=a");
        }
        port side : TranslationalMechanicalPort;
        port signal : LinearAccelerationSignalPort;
        attribute a : AccelerationValue;
    }

    part def RelativeLinearPositionSensor :> MechanicalComponent {
        doc /* Measures relative position between the two flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.RelPositionSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=s_rel");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port signal : LinearPositionSignalPort;
        attribute s_rel : LengthValue;
    }

    part def RelativeLinearSpeedSensor :> MechanicalComponent {
        doc /* Measures relative velocity between the two flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.RelSpeedSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=v_rel");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port signal : LinearVelocitySignalPort;
        attribute v_rel : SpeedValue;
    }

    part def RelativeLinearAccelerationSensor :> MechanicalComponent {
        doc /* Measures relative acceleration between the two flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.RelAccSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=a_rel");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port signal : LinearAccelerationSignalPort;
        attribute a_rel : AccelerationValue;
    }

    part def LinearForceSensor :> MechanicalComponent {
        doc /* Measures force through a rigid connection between the flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.ForceSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=f");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port signal : ForceSignalPort;
        attribute f : ForceValue;
    }

    part def LinearPowerSensor :> MechanicalComponent {
        doc /* Measures power transmitted through a rigid connection between the flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.PowerSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=power");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port signal : MechanicalPowerSignalPort;
        attribute power : PowerValue;
    }

    part def LinearMultiSensor :> MechanicalComponent {
        doc /* Measures power, velocity and force through a rigid connection. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sensors.MultiSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "powerSignal=power", "speedSignal=v", "forceSignal=f");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port powerSignal : MechanicalPowerSignalPort;
        port speedSignal : LinearVelocitySignalPort;
        port forceSignal : ForceSignalPort;
        attribute power : PowerValue;
        attribute v : SpeedValue;
        attribute f : ForceValue;
    }

    part def ConstantLinearSpeedSource :> MechanicalComponent {
        doc /* Prescribes a constant velocity relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.ConstantSpeed";
            parameters = ("speed=v_fixed");
            pins = ("side=flange");
        }
        port side : TranslationalMechanicalPort;
        attribute speed : SpeedValue;
    }

    part def LinearSpeedDependentForceSource :> MechanicalComponent {
        doc /* Applies the MSL linear speed-dependent force law relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.LinearSpeedDependentForce";
            parameters = ("nominalForce=f_nominal", "nominalSpeed=v_nominal");
            pins = ("side=flange");
        }
        port side : TranslationalMechanicalPort;
        attribute nominalForce : ForceValue;
        attribute nominalSpeed : SpeedValue;
    }

    part def QuadraticSpeedDependentForceSource :> MechanicalComponent {
        doc /* Applies the MSL quadratic speed-dependent force law relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.QuadraticSpeedDependentForce";
            parameters = ("nominalForce=f_nominal", "nominalSpeed=v_nominal");
            pins = ("side=flange");
        }
        port side : TranslationalMechanicalPort;
        attribute nominalForce : ForceValue;
        attribute nominalSpeed : SpeedValue;
    }

    part def InverseSpeedDependentForceSource :> MechanicalComponent {
        doc /* Applies the MSL inverse speed-dependent force law relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.InverseSpeedDependentForce";
            parameters = ("nominalForce=f_nominal", "nominalSpeed=v_nominal", "regularizationSpeed=v0");
            pins = ("side=flange");
        }
        port side : TranslationalMechanicalPort;
        attribute nominalForce : ForceValue;
        attribute nominalSpeed : SpeedValue;
        attribute regularizationSpeed : SpeedValue;
    }

    part def SignalForceSource :> MechanicalComponent {
        doc /* Applies the commanded force relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.Force";
            pins = ("side=flange", "command=f");
        }
        port side : TranslationalMechanicalPort;
        port command : ~ForceSignalPort;
    }

    part def TwoFlangeForceSource :> MechanicalComponent {
        doc /* Applies the commanded force between two flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.Force2";
            pins = ("sideA=flange_a", "sideB=flange_b", "command=f");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        port command : ~ForceSignalPort;
    }

    part def LinearSpringDamper :> MechanicalComponent {
        doc /* Couples two flanges with a parallel linear spring and damper. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Components.SpringDamper";
            parameters = ("stiffness=c", "damping=d", "unstretchedLength=s_rel0", "nominalDisplacement=s_nominal");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        attribute stiffness : TranslationalStiffnessValue;
        attribute damping : TranslationalDampingValue;
        attribute unstretchedLength : LengthValue;
        attribute nominalDisplacement : LengthValue;
    }

    part def RigidRod :> MechanicalComponent {
        doc /* Couples two flanges with fixed length and no inertia. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Components.Rod";
            parameters = ("length=L");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        port sideA : TranslationalMechanicalPort;
        port sideB : TranslationalMechanicalPort;
        attribute length : LengthValue;
    }

    part def CommandedLinearAcceleration :> MechanicalComponent {
        doc /* Prescribes acceleration relative to the fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Translational.Sources.Accelerate";
            pins = ("side=flange", "command=a_ref");
        }
        port side : TranslationalMechanicalPort;
        port command : ~LinearAccelerationSignalPort;
    }
    // END GENERATED MECHANICS BINDINGS
}
