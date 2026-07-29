package Elan8 {
    package Electronics {
        package Io {
            import Elan8::Core::*;
            import Elan8::Electronics::Core::*;

            attribute def IoDirection;
            attribute def ResolutionClass;
            attribute def SamplingClass;

            part def IoChannel {
                attribute name : Name;
                attribute direction : IoDirection;
                attribute signalKind : SignalKind;
            }

            part def DigitalIoChannel :> IoChannel;

            part def AnalogIoChannel :> IoChannel {
                attribute resolutionClass : ResolutionClass;
                attribute samplingClass : SamplingClass;
            }

            part def SensorElectricalInterface :> ElectricalInterface;

            part def ActuatorElectricalInterface :> ElectricalInterface;

            part def GpioChannel :> DigitalIoChannel;

            part def PwmChannel :> DigitalIoChannel;

            part def QuadratureEncoderChannel :> DigitalIoChannel;
        }
    }
}
