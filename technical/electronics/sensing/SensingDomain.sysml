package Elan8 {
    package Electronics {
        package Sensing {
            private import Elan8::Electronics::Core::*;
            private import Elan8::Electronics::Interconnection::*;
            private import ISQ::*;
            private import ScalarValues::Boolean;

            abstract item def SensorMeasurement;

            item def BinaryStateMeasurement :> SensorMeasurement {
                attribute active : Boolean;
            }

            item def ContactStateMeasurement :> BinaryStateMeasurement;
            item def LiftStateMeasurement :> BinaryStateMeasurement;

            item def Acceleration3dMeasurement :> SensorMeasurement {
                attribute x : AccelerationValue;
                attribute y : AccelerationValue;
                attribute z : AccelerationValue;
            }

            item def AngularVelocity3dMeasurement :> SensorMeasurement {
                attribute x : AngularVelocityValue;
                attribute y : AngularVelocityValue;
                attribute z : AngularVelocityValue;
            }

            item def AngularPositionMeasurement :> SensorMeasurement {
                attribute value : AngularMeasureValue;
            }

            item def RotationalDisplacementMeasurement :> SensorMeasurement {
                attribute value : AngularMeasureValue;
            }

            abstract part def Sensor :> ElectronicsComponent;

            abstract part def DataSensor :> Sensor {
                doc /*
                 * Sensor with a generic data boundary. Protocol-specific sensor
                 * definitions redefine this port as I2C, UART, SPI, or another
                 * ElectronicCommunicationPort specialization.
                 */
                port data : ElectronicCommunicationPort;
            }

            abstract part def PassiveSensor :> Sensor {
                doc /* Sensor with no external electrical supply port. */
            }

            abstract part def PoweredSensor :> Sensor {
                doc /* Sensor that requires an external electrical supply. */
            }

            abstract part def DcPoweredSensor :> PoweredSensor {
                port power : ~DcPowerPort;
            }

            part def InertialMeasurementUnit :> DcPoweredSensor, DataSensor {
                item acceleration : Acceleration3dMeasurement;
                item angularVelocity : AngularVelocity3dMeasurement;
            }

            part def I2cInertialMeasurementUnit :> InertialMeasurementUnit {
                port data : I2cTargetPort :>> data;
            }

            part def UartInertialMeasurementUnit :> InertialMeasurementUnit {
                port data : UartPort :>> data;
            }

            abstract part def SwitchSensor :> PassiveSensor {
                port signal : GpioPort;
            }

            part def BumperSwitch :> SwitchSensor {
                item contactState : ContactStateMeasurement;
            }

            part def LiftSwitch :> SwitchSensor {
                item liftState : LiftStateMeasurement;
            }

            abstract part def Encoder :> Sensor;
            abstract part def RotationalEncoder :> Encoder;

            part def AbsoluteRotationalEncoder :> RotationalEncoder, DcPoweredSensor, DataSensor {
                item angularPosition : AngularPositionMeasurement;
            }

            part def I2cAbsoluteRotationalEncoder :> AbsoluteRotationalEncoder {
                port data : I2cTargetPort :>> data;
            }

            part def UartAbsoluteRotationalEncoder :> AbsoluteRotationalEncoder {
                port data : UartPort :>> data;
            }

            abstract part def QuadratureEncoderBase :> RotationalEncoder {
                port odometry : QuadratureEncoderPort;
                item rotationalDisplacement : RotationalDisplacementMeasurement;
            }

            part def QuadratureEncoder :> QuadratureEncoderBase, DcPoweredSensor;
            part def PassiveQuadratureEncoder :> QuadratureEncoderBase, PassiveSensor;
            part def PoweredQuadratureEncoder :> QuadratureEncoder;
        }
    }
}
