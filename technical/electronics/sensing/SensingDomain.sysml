package SensingDomain {
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;

    part def InertialMeasurementUnit :> ElectronicsComponent {
        port bus : I2cTargetPort;
    }

    abstract part def SwitchSensor :> ElectronicsComponent {
        port trigger : GpioPort;
    }

    part def BumperSwitch :> SwitchSensor ;
    part def LiftSwitch :> SwitchSensor;

    abstract part def Encoder :> ElectronicsComponent;

    part def QuadratureEncoder :> Encoder {
        port odometry : QuadratureEncoderPort;
    }
}

