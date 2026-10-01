package DeviceBus {
    private import Elan8::Communication::Core::*;

    attribute def BusSpeedClass;

    part def DeviceBusChannel :> CommunicationChannel {
        attribute speedClass : BusSpeedClass;
    }

    part def UsbBus :> DeviceBusChannel;
}
