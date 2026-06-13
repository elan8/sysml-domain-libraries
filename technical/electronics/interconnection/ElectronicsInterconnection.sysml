package ElectronicsInterconnection {
    import ElectronicsCore::*;
    import CommunicationCore::*;

    port def I2cPort;
    port def SpiPort;
    port def UartPort;
    port def PowerRailPort;
    port def GpioPort;
    port def PwmPort :> GpioPort;
    port def QuadratureEncoderPort;
    port def ThreePhaseMotorPort;

    interface def I2cNodeInterface {
        end masterPort : I2cPort;
        end slavePort : ~I2cPort;
    }

    interface def SpiNodeInterface {
        end masterPort : SpiPort;
        end slavePort : ~SpiPort;
    }

    interface def UartLinkInterface {
        end hostPort : UartPort;
        end devicePort : ~UartPort;
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
