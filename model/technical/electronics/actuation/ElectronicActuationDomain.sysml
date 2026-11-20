package Actuation {
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import ISQ::*;
    private import Quantities::*;

    attribute def TorqueConstantValue :> ScalarQuantityValue {
        doc /*
         * Torque per unit current of a motor, for example 0.05 [N * m / A]. In SI it equals the
         * back-EMF constant in V·s/rad.
         */
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

    part def BldcMotor :> DcMotor {
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
