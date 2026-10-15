package Buses {
    doc /*
     * Wired buses between electronic components. A bus is a physical medium
     * with its own timing; its nodes connect through the bus ports in
     * Elan8::Electronics::Interconnection.
     */
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import ISQ::*;

    enum def BusTopology {
        pointToPoint;
        multiDrop;
        daisyChain;
    }

    part def ElectronicBus :> ElectronicsComponent {
        attribute bitRate : BinaryDigitRateValue[0..1];
        attribute topology : BusTopology[0..1];
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
