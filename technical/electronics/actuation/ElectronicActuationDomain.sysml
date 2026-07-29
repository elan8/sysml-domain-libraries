package Elan8 {
    package Electronics {
        package Actuation {
            private import Elan8::Electronics::Core::*;
            private import Elan8::Electronics::Interconnection::*;
            private import Elan8::Mechanical::Interconnection::*;
            private import ISQ::*;

            abstract part def ElectricalActuator :> ElectronicsComponent {
                attribute ratedPower : PowerValue;
            }

            abstract part def Motor :> ElectricalActuator {
                port mechanicalOutput : RotationalMechanicalPort;
            }

            abstract part def DcMotor :> Motor;

            part def BrushedDcMotor :> DcMotor {
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
    }
}
