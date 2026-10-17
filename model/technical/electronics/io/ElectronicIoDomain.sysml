package Io {
    doc /*
     * Input and output channels of an electronic component. A channel's
     * direction is the direction of the port that uses it, not an attribute.
     */
    private import Elan8::Electronics::Core::*;
    private import ISQ::*;
    private import ScalarValues::Natural;

    part def IoChannel {
        attribute signalKind : SignalKind[0..1];
    }

    part def DigitalIoChannel :> IoChannel;

    part def AnalogIoChannel :> IoChannel {
        attribute resolution : Natural[0..1] {
            doc /* Converter resolution in bits. */
        }
        attribute samplingRate : FrequencyValue[0..1];
    }

    part def SensorElectricalInterface :> ElectricalInterface;

    part def ActuatorElectricalInterface :> ElectricalInterface;

    part def GpioChannel :> DigitalIoChannel;

    part def PwmChannel :> DigitalIoChannel {
        attribute frequency : FrequencyValue[0..1];
    }

    part def QuadratureEncoderChannel :> DigitalIoChannel;
}
