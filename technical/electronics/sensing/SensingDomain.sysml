package SensingDomain {
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;

    part def InertialMeasurementUnit :> ElectronicsComponent {
        port bus : I2cPort;
    }
}
