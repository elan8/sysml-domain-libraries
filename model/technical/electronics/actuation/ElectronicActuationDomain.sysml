package Actuation {
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import ISQ::*;
    private import Quantities::*;
    private import ScalarValues::*;

    attribute def TorqueConstantValue :> ScalarQuantityValue {
        doc /*
         * Torque per unit current of a motor, for example 0.05 [N * m / A]. In SI it equals the
         * back-EMF constant in V·s/rad.
         */
    }

    part def RotationalElectromechanicalConverter :> ElectronicsComponent {
        doc /*
         * Ideal conversion between electrical and shaft power with a fixed housing.
         * Positive current into terminal1 produces positive shaft torque.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Basic.RotationalEMF";
            parameters = ("torqueConstant=k");
            pins = ("terminal1=p", "terminal2=n", "shaft=flange");
        }
        attribute torqueConstant : TorqueConstantValue;
        port terminal1 : ElectricalTerminalPort;
        port terminal2 : ElectricalTerminalPort;
        port shaft : RotationalMechanicalPort;
    }

    abstract part def ElectricalActuator :> ElectronicsComponent {
        attribute ratedPower : PowerValue;
    }

    abstract part def Motor :> ElectricalActuator {
        port mechanicalOutput : RotationalMechanicalPort;
    }

    abstract part def DcMotor :> Motor;

    part def BrushedDcMotor :> DcMotor {
        doc /*
         * A brushed DC motor: the armature resistance and inductance in series with a back-EMF,
         * and a rotor with its inertia. `terminal1` is the positive terminal: a positive current
         * into it turns the shaft in the positive direction. `electricalInput` is the
         * architecture-level view of the same supply and carries no Modelica.
         *
         * This is also the torque-level equivalent of a brushless or permanent-magnet
         * synchronous motor under ideal commutation or field-oriented control, with the
         * line-to-line resistance and inductance and the torque constant.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Elan8.Electronics.Actuation.BrushedDcMotor";
        }
        attribute armatureResistance : ResistanceValue;
        attribute armatureInductance : InductanceValue;
        attribute torqueConstant : TorqueConstantValue;
        attribute rotorInertia : MomentOfInertiaValue;
        port terminal1 : ElectricalTerminalPort;
        port terminal2 : ElectricalTerminalPort;
        port electricalInput : ~DcDrivePort;
    }

    part def PermanentMagnetSynchronousMotor :> AcMotor {
        doc /*
         * A permanent-magnet synchronous motor, which is also a brushless DC motor when it is
         * driven with field-oriented control. The Modelica class is the dq-frame model: its two
         * inputs, `vd` and `vq`, are the stator voltages in the rotor frame, so a simulation takes
         * them from a controller and needs no inverter or phase transformation. Positive `vq`
         * turns the shaft in the positive direction. `electricalInput` is the
         * architecture-level three-phase view and carries no Modelica.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Elan8.Electronics.Actuation.PermanentMagnetSynchronousMotor";
        }
        attribute statorResistance : ResistanceValue;
        attribute statorInductanceD : InductanceValue;
        attribute statorInductanceQ : InductanceValue;
        attribute permanentMagnetFlux : MagneticFluxValue;
        attribute polePairs : Real;
        attribute rotorInertia : MomentOfInertiaValue;
        port electricalInput : ~ThreePhaseDrivePort;
    }

    part def BldcMotor :> DcMotor {
        doc /*
         * A star-connected brushless DC motor with an isolated neutral, modelled phase by phase
         * and fed by an averaged three-phase inverter: each phase has a resistance, an
         * inductance and a back-EMF that follows the rotor angle. `emfShape` selects the
         * back-EMF waveform, 0 for sinusoidal or 1 for trapezoidal with 120 degree flat tops, so
         * a simulation can compare field-oriented control with block commutation on the same
         * motor. The Modelica class takes one duty-cycle input per phase (`dutyA`, `dutyB`,
         * `dutyC`, 0 to 1, each the average of a half bridge on `dcLinkVoltage`) and offers the
         * rotor angle and speed, the three phase currents and the air-gap torque as variables.
         * Switching and its ripple are not modelled. With sinusoidal back-EMF it is equivalent
         * to `PermanentMagnetSynchronousMotor` with equal direct and quadrature inductances.
         * `electricalInput` is the architecture-level three-phase view and carries no Modelica.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Elan8.Electronics.Actuation.ThreePhaseBldcMotor";
        }
        attribute phaseResistance : ResistanceValue;
        attribute phaseInductance : InductanceValue;
        attribute permanentMagnetFlux : MagneticFluxValue;
        attribute polePairs : Real;
        attribute emfShape : Real;
        attribute rotorInertia : MomentOfInertiaValue;
        attribute dcLinkVoltage : ElectricPotentialValue;
        port electricalInput : ~ThreePhaseDrivePort;
    }

    abstract part def AcMotor :> Motor;

    part def SinglePhaseAcMotor :> AcMotor {
        port electricalInput : ~SinglePhaseAcDrivePort;
    }

    part def ThreePhaseAcMotor :> AcMotor {
        port electricalInput : ~ThreePhaseDrivePort;
    }

    part def StepperMotor :> Motor {
        doc /*
         * A two-phase hybrid stepper motor on two current-regulated full bridges, the way a
         * microstepping driver feeds it. The Modelica class takes two inputs: `fieldAngle`, the
         * electrical angle of the stator field in radians (a driver turns its step count into it,
         * one full step being a quarter of a cycle), and `currentCommand`, the peak phase
         * current. Each phase has a resistance, an inductance and a back-EMF that follows the
         * rotor angle times `rotorTeeth`, and each bridge regulates its phase current with a gain
         * of `chopperGain` volts per ampere of error, limited to `supplyVoltage`: the torque
         * therefore falls with speed once the back-EMF and the inductance use up the supply.
         * `detentTorque` is the cogging torque of the unpowered motor. The class offers the rotor
         * angle and speed, the two phase currents and voltages and the air-gap torque as
         * variables. Switching and its ripple are not modelled. A closed-loop stepper takes its
         * `fieldAngle` from the rotor angle plus a quarter of a cycle; an open-loop one from the
         * step count. `electricalInput` is the architecture-level two-phase view and carries no
         * Modelica.
         */
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Elan8.Electronics.Actuation.StepperMotor";
        }
        attribute phaseResistance : ResistanceValue;
        attribute phaseInductance : InductanceValue;
        attribute torqueConstant : TorqueConstantValue;
        attribute rotorTeeth : Real;
        attribute detentTorque : TorqueValue;
        attribute rotorInertia : MomentOfInertiaValue;
        attribute supplyVoltage : ElectricPotentialValue;
        attribute chopperGain : Real;
        port electricalInput : ~TwoPhaseDrivePort;
    }

    abstract part def Solenoid :> ElectricalActuator {
        port mechanicalOutput : TranslationalMechanicalPort;
    }

    part def DcSolenoid :> Solenoid {
        port electricalInput : ~DcDrivePort;
    }

    part def AcSolenoid :> Solenoid {
        port electricalInput : ~SinglePhaseAcDrivePort;
    }

    abstract part def ServoActuator :> ElectricalActuator;

    abstract part def RotationalServoActuator :> ServoActuator {
        port mechanicalOutput : RotationalMechanicalPort;
    }

    abstract part def TranslationalServoActuator :> ServoActuator {
        port mechanicalOutput : TranslationalMechanicalPort;
    }

    part def PwmRotationalServoActuator :> RotationalServoActuator {
        port power : ~PowerRailPort;
        port command : ~PwmPort;
    }

    part def PwmTranslationalServoActuator :> TranslationalServoActuator {
        port power : ~PowerRailPort;
        port command : ~PwmPort;
    }

    abstract part def ElectricalActuatorDriver :> ElectronicsComponent;
    abstract part def MotorDriver :> ElectricalActuatorDriver;

    part def HBridgeMotorDriver :> MotorDriver {
        port supply : ~PowerRailPort;
        port command : ~PwmPort;
        port driveOutput : DcDrivePort;
        port fault : GpioPort;
    }

    part def ThreePhaseMotorDriver :> MotorDriver {
        port supply : ~PowerRailPort;
        port command : ~PwmPort;
        port driveOutput : ThreePhaseDrivePort;
        port fault : GpioPort;
    }

    part def StepperMotorDriver :> MotorDriver {
        port supply : ~PowerRailPort;
        port step : ~GpioPort;
        port direction : ~GpioPort;
        port driveOutput : TwoPhaseDrivePort;
        port fault : GpioPort;
    }

    part def SolenoidDriver :> ElectricalActuatorDriver {
        port supply : ~PowerRailPort;
        port command : ~PwmPort;
        port driveOutput : DcDrivePort;
        port fault : GpioPort;
    }

    part def ThreePhaseServoDrive :> ThreePhaseMotorDriver {
        port feedback : ~QuadratureEncoderPort;
    }
}
