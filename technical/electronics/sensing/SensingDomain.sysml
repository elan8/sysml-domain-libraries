package SensingDomain {
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;

    part def InertialMeasurementUnit :> ElectronicsComponent {
        port bus : I2cTargetPort;
    }

    part def BumperSwitch :> ElectronicsComponent {
        port hazard : GpioPort;
    }

    part def LiftSwitch :> ElectronicsComponent {
        port hazard : GpioPort;
    }
}
