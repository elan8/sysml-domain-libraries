package Elan8 {
    package Electronics {
        package Interconnection {
            import Elan8::Core::*;
            import Elan8::Electronics::Core::*;

            attribute def ConnectorType;

            part def ElectronicConnector :> PhysicalComponent {
                attribute connectorType : ConnectorType;
            }

            part def BoardConnector :> ElectronicConnector;

            part def WiringHarness :> PhysicalComponent {
                part connectors : ElectronicConnector[2..*];
            }

            port def ElectricalTerminalPort;

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

            port def ElectricalPowerPort;
            port def DcPowerPort :> ElectricalPowerPort;
            port def AcPowerPort :> ElectricalPowerPort;
            port def PowerRailPort :> DcPowerPort;

            port def ElectricalDrivePort :> ElectricalPowerPort;
            port def DcDrivePort :> ElectricalDrivePort, DcPowerPort;
            port def SinglePhaseAcDrivePort :> ElectricalDrivePort, AcPowerPort;
            port def PolyphaseDrivePort :> ElectricalDrivePort;
            port def TwoPhaseDrivePort :> PolyphaseDrivePort;
            port def ThreePhaseDrivePort :> PolyphaseDrivePort;

            port def GpioPort;
            port def PwmPort :> GpioPort;
            port def QuadratureEncoderPort;

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

            interface def ElectricalTerminalLink {
                end terminalA : ElectricalTerminalPort;
                end terminalB : ElectricalTerminalPort;
            }

            interface def DcPowerSupplyLink {
                end sourcePort : DcPowerPort;
                end loadPort : ~DcPowerPort;
            }

            interface def AcPowerSupplyLink {
                end sourcePort : AcPowerPort;
                end loadPort : ~AcPowerPort;
            }

            interface def GpioSignalInterface {
                end sourcePort : GpioPort;
                end sinkPort : ~GpioPort;
            }

            interface def PwmDriveInterface {
                end driverPort : PwmPort;
                end actuatorPort : ~PwmPort;
            }

            interface def DcDriveLink {
                end driverPort : DcDrivePort;
                end actuatorPort : ~DcDrivePort;
            }

            interface def SinglePhaseAcDriveLink {
                end driverPort : SinglePhaseAcDrivePort;
                end actuatorPort : ~SinglePhaseAcDrivePort;
            }

            interface def TwoPhaseDriveLink {
                end driverPort : TwoPhaseDrivePort;
                end actuatorPort : ~TwoPhaseDrivePort;
            }

            interface def ThreePhaseDriveLink {
                end driverPort : ThreePhaseDrivePort;
                end actuatorPort : ~ThreePhaseDrivePort;
            }

            interface def QuadratureEncoderInterface {
                end encoderPort : QuadratureEncoderPort;
                end receiverPort : ~QuadratureEncoderPort;
            }
        }
    }
}
