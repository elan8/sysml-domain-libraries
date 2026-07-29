package SensorSuiteExample {
    private import ElectronicsCore::*;
    private import SensingDomain::*;

    part def SensorSuite :> ElectronicsComponent {
        part imu : I2cInertialMeasurementUnit;
        part bumper : BumperSwitch;
        part lift : LiftSwitch;
        part wheelEncoder : PoweredQuadratureEncoder;
    }
}
