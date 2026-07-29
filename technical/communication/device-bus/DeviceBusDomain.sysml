package Elan8 {
    package Communication {
        package DeviceBus {
            import Elan8::Communication::Core::*;

            attribute def BusSpeedClass;

            part def DeviceBusChannel :> CommunicationChannel {
                attribute speedClass : BusSpeedClass;
            }

            part def UsbBus :> DeviceBusChannel;
        }
    }
}
