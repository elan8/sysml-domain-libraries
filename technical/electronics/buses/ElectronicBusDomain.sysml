package ElectronicBusDomain {
    import Core::Name;
    import ElectronicsCore::*;
    import CommunicationCore::*;
    import ElectronicsInterconnection::*;

    attribute def BusType;
    attribute def BusSpeedClass;
    attribute def TopologyClass;

    part def ElectronicBus :> CommunicationChannel {
        attribute busType : BusType;
        attribute speedClass : BusSpeedClass;
        attribute topologyClass : TopologyClass;
    }

    part def BusNode :> ElectronicsComponent;

    part def I2cControllerNode :> BusNode {
        port busPort : I2cControllerPort;
    }

    part def I2cTargetNode :> BusNode {
        port busPort : I2cTargetPort;
    }

    part def SpiControllerNode :> BusNode {
        port busPort : SpiControllerPort;
    }

    part def SpiPeripheralNode :> BusNode {
        port busPort : SpiPeripheralPort;
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

