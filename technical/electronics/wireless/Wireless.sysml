package Elan8 {
    package Electronics {
        package Wireless {
            import Elan8::Communication::Core::*;
            import Elan8::Communication::Wireless::*;
            import Elan8::Electronics::Core::*;
            import Elan8::Electronics::Interconnection::*;
            import Elan8::Software::Core::*;

            part def WirelessModule :> ElectronicsComponent {
                port hostLink : SerialCommunicationPort;
                ref wirelessChannel : WirelessCommunicationChannel;
            }
        }
    }
}
