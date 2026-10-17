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

    item def InfraredSignal {
        doc /* Modulated infrared light used to signal or detect presence. */
        attribute wavelength : LengthValue[0..1];
        attribute carrierFrequency : FrequencyValue[0..1];
    }

    port def InfraredPort {
        doc /* Emits infrared light; a receiving component uses the conjugated port. */
        out item signal : InfraredSignal;
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

    abstract part def I2cDataSensor :> DataSensor {
        port data : I2cTargetPort :>> data;
    }

    abstract part def UartDataSensor :> DataSensor {
        port data : UartPort :>> data;
    }

    abstract part def PassiveSensor :> Sensor {
        doc /* Sensor with no external electrical supply port. */
    }

    abstract part def PoweredSensor :> Sensor {
        doc /* Sensor that requires an external electrical supply. */
    }

    abstract part def DcPoweredSensor :> PoweredSensor {
        port power : ~PowerRailPort;
    }

    part def InertialMeasurementUnit :> DcPoweredSensor, DataSensor {
        item acceleration : Acceleration3dMeasurement;
        item angularVelocity : AngularVelocity3dMeasurement;
    }

    part def I2cInertialMeasurementUnit
        :> InertialMeasurementUnit, I2cDataSensor;

    part def UartInertialMeasurementUnit
        :> InertialMeasurementUnit, UartDataSensor;

    part def InfraredTransmitter :> ElectronicsComponent {
        port power : ~PowerRailPort;
        port emission : InfraredPort;
    }

    part def InfraredReceiver :> DcPoweredSensor {
        port reception : ~InfraredPort;
        port detection : GpioPort;
        item observation : BinaryStateMeasurement;
    }

    part def SwitchSensor :> PassiveSensor {
        doc /* A mechanical contact read as a digital input: a bumper, a lid or a lift switch. */
        port signal : GpioPort;
        item contactState : ContactStateMeasurement;
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
