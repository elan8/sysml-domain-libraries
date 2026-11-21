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
    private import MeasurementReferences::DimensionOneValue;
    private import Quantities::*;

    attribute def RotationalStiffnessValue :> ScalarQuantityValue {
        doc /* Torque per unit twist, for example 1 [N * m / rad]. */
    }

    attribute def RotationalDampingValue :> ScalarQuantityValue {
        doc /* Torque per unit angular velocity of a viscous damper, for example 0.04 [N * m * s / rad]. */
    }

    attribute def RotationPerLengthValue :> ScalarQuantityValue {
        doc /* Angular displacement per unit linear displacement, for example 10 [rad/m]. */
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

    // BEGIN GENERATED MECHANICS BINDINGS
    port def AngularAccelerationSignalPort {
        out attribute angularAcceleration : AngularAccelerationValue;
    }

    port def AngularPositionSignalPort {
        out attribute angle : AngularMeasureValue;
    }

    port def AngularVelocitySignalPort {
        out attribute angularVelocity : AngularVelocityValue;
    }

    port def TorqueSignalPort {
        out attribute torque : TorqueValue;
    }

    part def ShaftAngleSensor :> MechanicalComponent {
        doc /* Measures the shaft's absolute angle without exerting torque. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.AngleSensor";
            pins = ("shaft=flange", "signal=phi");
        }
        port shaft : RotationalMechanicalPort;
        port signal : AngularPositionSignalPort;
        attribute phi : AngularMeasureValue;
    }

    part def ShaftAccelerationSensor :> MechanicalComponent {
        doc /* Measures the shaft's absolute angular acceleration without exerting torque. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.AccSensor";
            pins = ("shaft=flange", "signal=a");
        }
        port shaft : RotationalMechanicalPort;
        port signal : AngularAccelerationSignalPort;
        attribute a : AngularAccelerationValue;
    }

    part def ShaftSpeedSensor :> MechanicalComponent {
        doc /* Measures the shaft's absolute angular velocity without exerting torque. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.SpeedSensor";
            pins = ("shaft=flange", "signal=w");
        }
        port shaft : RotationalMechanicalPort;
        port signal : AngularVelocitySignalPort;
        attribute w : AngularVelocityValue;
    }

    part def RelativeShaftAngleSensor :> MechanicalComponent {
        doc /* Measures relative angle between the shafts. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.RelAngleSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=phi_rel");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port signal : AngularPositionSignalPort;
        attribute phi_rel : AngularMeasureValue;
    }

    part def RelativeShaftSpeedSensor :> MechanicalComponent {
        doc /* Measures relative angular velocity between the shafts. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.RelSpeedSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=w_rel");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port signal : AngularVelocitySignalPort;
        attribute w_rel : AngularVelocityValue;
    }

    part def RelativeShaftAccelerationSensor :> MechanicalComponent {
        doc /* Measures relative angular acceleration between the shafts. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.RelAccSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=a_rel");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port signal : AngularAccelerationSignalPort;
        attribute a_rel : AngularAccelerationValue;
    }

    part def ShaftTorqueSensor :> MechanicalComponent {
        doc /* Measures torque through a rigid connection between the shafts. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.TorqueSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=tau");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port signal : TorqueSignalPort;
        attribute tau : TorqueValue;
    }

    part def ShaftPowerSensor :> MechanicalComponent {
        doc /* Measures power transmitted through a rigid connection between the shafts. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.PowerSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "signal=power");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port signal : MechanicalPowerSignalPort;
        attribute power : PowerValue;
    }

    part def ShaftMultiSensor :> MechanicalComponent {
        doc /* Measures power, angular velocity and torque through a rigid shaft connection. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sensors.MultiSensor";
            pins = ("sideA=flange_a", "sideB=flange_b", "powerSignal=power", "speedSignal=w", "torqueSignal=tau");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port powerSignal : MechanicalPowerSignalPort;
        port speedSignal : AngularVelocitySignalPort;
        port torqueSignal : TorqueSignalPort;
        attribute power : PowerValue;
        attribute w : AngularVelocityValue;
        attribute tau : TorqueValue;
    }

    part def ConstantShaftSpeedSource :> MechanicalComponent {
        doc /* Prescribes a constant velocity relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.ConstantSpeed";
            parameters = ("speed=w_fixed");
            pins = ("side=flange");
        }
        port side : RotationalMechanicalPort;
        attribute speed : AngularVelocityValue;
    }

    part def LinearSpeedDependentTorqueSource :> MechanicalComponent {
        doc /* Applies the MSL linear speed-dependent torque law relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.LinearSpeedDependentTorque";
            parameters = ("nominalTorque=tau_nominal", "nominalSpeed=w_nominal");
            pins = ("side=flange");
        }
        port side : RotationalMechanicalPort;
        attribute nominalTorque : TorqueValue;
        attribute nominalSpeed : AngularVelocityValue;
    }

    part def QuadraticSpeedDependentTorqueSource :> MechanicalComponent {
        doc /* Applies the MSL quadratic speed-dependent torque law relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque";
            parameters = ("nominalTorque=tau_nominal", "nominalSpeed=w_nominal");
            pins = ("side=flange");
        }
        port side : RotationalMechanicalPort;
        attribute nominalTorque : TorqueValue;
        attribute nominalSpeed : AngularVelocityValue;
    }

    part def InverseSpeedDependentTorqueSource :> MechanicalComponent {
        doc /* Applies the MSL inverse speed-dependent torque law relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.InverseSpeedDependentTorque";
            parameters = ("nominalTorque=tau_nominal", "nominalSpeed=w_nominal", "regularizationSpeed=w0");
            pins = ("side=flange");
        }
        port side : RotationalMechanicalPort;
        attribute nominalTorque : TorqueValue;
        attribute nominalSpeed : AngularVelocityValue;
        attribute regularizationSpeed : AngularVelocityValue;
    }

    part def SignalTorqueSource :> MechanicalComponent {
        doc /* Applies the commanded torque relative to its fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.Torque";
            pins = ("side=flange", "command=tau");
        }
        port side : RotationalMechanicalPort;
        port command : ~TorqueSignalPort;
    }

    part def TwoFlangeTorqueSource :> MechanicalComponent {
        doc /* Applies the commanded torque between two flanges. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.Torque2";
            pins = ("sideA=flange_a", "sideB=flange_b", "command=tau");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        port command : ~TorqueSignalPort;
    }

    part def StepTorqueSource :> MechanicalComponent {
        doc /* Applies initialTorque before stepTime, then initialTorque plus stepHeight. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.TorqueStep";
            parameters = ("initialTorque=offsetTorque", "stepHeight=stepTorque", "stepTime=startTime");
            pins = ("side=flange");
        }
        port side : RotationalMechanicalPort;
        attribute initialTorque : TorqueValue;
        attribute stepHeight : TorqueValue;
        attribute stepTime : DurationValue;
    }

    part def RigidShaftOffset :> MechanicalComponent {
        doc /* Couples two shafts with a fixed angle offset and no inertia. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.Disc";
            parameters = ("angleOffset=deltaPhi");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        attribute angleOffset : AngularMeasureValue;
    }

    part def TorsionalSpringDamper :> MechanicalComponent {
        doc /* Couples two shafts with a parallel linear spring and damper. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.SpringDamper";
            parameters = ("stiffness=c", "damping=d", "unstretchedAngle=phi_rel0", "nominalAngle=phi_nominal");
            pins = ("sideA=flange_a", "sideB=flange_b");
        }
        port sideA : RotationalMechanicalPort;
        port sideB : RotationalMechanicalPort;
        attribute stiffness : RotationalStiffnessValue;
        attribute damping : RotationalDampingValue;
        attribute unstretchedAngle : AngularMeasureValue;
        attribute nominalAngle : AngularMeasureValue;
    }

    part def CommandedShaftAcceleration :> MechanicalComponent {
        doc /* Prescribes acceleration relative to the fixed support. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Sources.Accelerate";
            pins = ("side=flange", "command=a_ref");
        }
        port side : RotationalMechanicalPort;
        port command : ~AngularAccelerationSignalPort;
    }

    part def IdealPlanetaryGear :> MechanicalComponent {
        doc /* An ideal planetary gear with sun, carrier and ring shafts. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.IdealPlanetary";
            parameters = ("ringToSunRatio=ratio");
            pins = ("sun=sun", "carrier=carrier", "ring=ring");
        }
        port sun : RotationalMechanicalPort;
        port carrier : RotationalMechanicalPort;
        port ring : RotationalMechanicalPort;
        attribute ringToSunRatio : DimensionOneValue;
    }

    part def IdealRotationToTranslationGear :> MechanicalComponent {
        doc /* Couples shaft angle to linear displacement through a fixed ratio. */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Mechanics.Rotational.Components.IdealGearR2T";
            parameters = ("rotationPerLength=ratio");
            pins = ("shaft=flangeR", "side=flangeT");
        }
        port shaft : RotationalMechanicalPort;
        port side : TranslationalMechanicalPort;
        attribute rotationPerLength : RotationPerLengthValue;
    }
    // END GENERATED MECHANICS BINDINGS
}
