package Electronics {
    public import Actuation;
    public import Assembly;
    public import Board;
    public import Buses;
    public import Components;
    public import Compute;
    package Core {
        private import Elan8::Core::*;
        private import ISQ::*;

        attribute def SignalKind;
        attribute def VoltageClass;
        attribute def CurrentClass;
        attribute def TimingClass;
        attribute def PinCount;

        part def ElectronicsComponent :> PhysicalComponent {
            attribute powerDraw : PowerValue;
        }

        part def ElectricalInterface {
            attribute interfaceName : Name;
            attribute signalKind : SignalKind;
            attribute voltageClass : VoltageClass;
            attribute timingClass : TimingClass;
        }

        part def PinGroup {
            attribute groupName : Name;
            attribute pinCount : PinCount;
        }

        item def ElectricalSignal  {
            attribute signalName : Name;
            attribute signalKind : SignalKind;
        }
    }
    package Interconnection {
        private import Elan8::Core::*;
        private import Elan8::Electronics::Core::*;
        private import Elan8::PhysicalModeling::*;
        private import ISQ::*;

        attribute def ConnectorType;

        port def ElectricalTerminalPort {
            doc /*
             * potential (across) and current (through), per Elan8::PhysicalModeling.
             * Optional to set: topology-only usages (board connectors, harness
             * conductors) leave them unset. Component constitutive equations and
             * a future simulation compiler rely on them once set.
             */
            attribute potential : ElectricPotentialValue {
                @AcrossVariable;
            }
            attribute current : ElectricCurrentValue {
                @ThroughVariable;
            }
        }

        part def ElectronicConnector :> PhysicalComponent {
            attribute connectorType : ConnectorType;
            port terminals : ElectricalTerminalPort[1..*];
        }

        part def BoardConnector :> ElectronicConnector;

        part def HarnessConductor :> PhysicalComponent {
            port endA : ElectricalTerminalPort;
            port endB : ElectricalTerminalPort;
            connect endA to endB;
        }

        part def WiringHarness :> PhysicalComponent {
            part connectors : ElectronicConnector[2..*];
            part conductors : HarnessConductor[1..*];
        }

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
    public import Io;
    public import Power;
    public import Sensing;
    package Wireless {
        private import Elan8::Communication::Core::*;
        private import Elan8::Communication::Wireless::*;
        private import Elan8::Electronics::Core::*;
        private import Elan8::Electronics::Interconnection::*;
        private import Elan8::Software::Core::*;

        part def WirelessModule :> ElectronicsComponent {
            port power : ~PowerRailPort;
            port hostLink : SerialCommunicationPort;
            ref wirelessChannel : WirelessCommunicationChannel;
        }
    }
}
