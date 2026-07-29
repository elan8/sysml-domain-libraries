package Elan8 {
    package Communication {
        package Wireless {
            import Elan8::Communication::Core::*;
            import Elan8::Electronics::Core::*;
            import Elan8::Electronics::Interconnection::*;
            import Elan8::Software::Core::*;

            enum def Protocol {
                Bluetooth;
                BluetoothLowEnergy;
                WiFi;
            }

            attribute def RadioBand;
            attribute def WirelessProtocolName;

            part def WirelessCommunicationChannel :> CommunicationChannel{
                attribute protocol : Protocol;
            }
        }
    }
}
