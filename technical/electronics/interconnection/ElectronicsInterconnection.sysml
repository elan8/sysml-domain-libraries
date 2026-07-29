package ElectronicsInterconnection {
    import ElectronicsCore::*;

    port def ElectronicCommunicationPort;
    port def SerialCommunicationPort :> ElectronicCommunicationPort;

    port def I2cPort :> SerialCommunicationPort {
        inout item clock : ElectricalSignal;
        inout item data : ElectricalSignal;
    }
    port def I2cControllerPort :> I2cPort;
    port def I2cTargetPort :> I2cPort;

    port def SpiPort :> SerialCommunicationPort;
    port def SpiControllerPort :> SpiPort {
        out item clock : ElectricalSignal;
        out item controllerData : ElectricalSignal;
        in item peripheralData : ElectricalSignal;
        out item chipSelect : ElectricalSignal;
    }
    port def SpiPeripheralPort :> SpiPort {
        in item clock : ElectricalSignal;
        in item controllerData : ElectricalSignal;
        out item peripheralData : ElectricalSignal;
        in item chipSelect : ElectricalSignal;
    }

    port def UartPort :> SerialCommunicationPort {
        out item transmit : ElectricalSignal;
        in item receive : ElectricalSignal;
    }

    port def PowerRailPort;
    port def GpioPort;
    port def PwmPort :> GpioPort;
    port def QuadratureEncoderPort;
    port def ThreePhaseMotorPort;

    interface def I2cLink {
        end controllerPort : I2cControllerPort;
        end targetPort : I2cTargetPort;
    }

    interface def SpiLink {
        end controllerPort : SpiControllerPort;
        end peripheralPort : SpiPeripheralPort;
    }

    interface def UartLink {
        end peerAPort : UartPort;
        end peerBPort : ~UartPort;
    }

    interface def PowerRailSupplyInterface {
        end sourcePort : PowerRailPort;
        end loadPort : ~PowerRailPort;
    }

    interface def GpioSignalInterface {
        end sourcePort : GpioPort;
        end sinkPort : ~GpioPort;
    }

    interface def PwmDriveInterface {
        end driverPort : PwmPort;
        end actuatorPort : ~PwmPort;
    }

    interface def ThreePhaseMotorDriveInterface {
        end driverPort : ThreePhaseMotorPort;
        end motorPort : ~ThreePhaseMotorPort;
    }

    interface def QuadratureEncoderInterface {
        end encoderPort : QuadratureEncoderPort;
        end receiverPort : ~QuadratureEncoderPort;
    }
}
