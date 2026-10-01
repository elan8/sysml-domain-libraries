package SensorSuite {
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Sensing::*;

    part def SensorSuite :> ElectronicsComponent {
        part imu : I2cInertialMeasurementUnit;
        part bumper : BumperSwitch;
        part lift : LiftSwitch;
        part wheelEncoder : PoweredQuadratureEncoder;
    }
}
