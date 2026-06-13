package ElectronicBusDomain {
    import SoftwareCore::*;
    import ElectronicsCore::*;
    import CommunicationCore::*;
    import ElectronicsInterconnection::*;

    attribute def BusType;
    attribute def BusSpeedClass;
    attribute def TopologyClass;

    part def ElectronicBus :> CommunicationChannel {
        attribute busName : Name;
        attribute busType : BusType;
        attribute speedClass : BusSpeedClass;
        attribute topologyClass : TopologyClass;
    }

    part def BusNode :> ElectronicsComponent {
        attribute nodeName : Name;
    }

    part def I2cBusMasterNode :> BusNode {
        port busPort : I2cPort;
    }

    part def I2cBusSlaveNode :> BusNode {
        port busPort : ~I2cPort;
    }

    part def SpiBusMasterNode :> BusNode {
        port busPort : SpiPort;
    }

    part def SpiBusSlaveNode :> BusNode {
        port busPort : ~SpiPort;
    }

    part def UartHostNode :> BusNode {
        port busPort : UartPort;
    }

    part def UartDeviceNode :> BusNode {
        port busPort : ~UartPort;
    }

    part def I2cBus :> ElectronicBus;
    part def SmbusBus :> I2cBus;
    part def SpiBus :> ElectronicBus;
    part def UartBus :> ElectronicBus;
    part def CanBus :> ElectronicBus;
}

