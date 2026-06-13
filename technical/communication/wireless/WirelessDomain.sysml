package WirelessDomain {
    import CommunicationCore::*;
    import ElectronicsCore::*;
    import ElectronicsInterconnection::*;
    import SoftwareCore::*;

    attribute def RadioBand;
    attribute def WirelessProtocolName;

    part def BleCommunicationChannel :> CommunicationChannel {
        attribute protocolName : WirelessProtocolName;
    }

    part def WiFiCommunicationChannel :> CommunicationChannel {
        attribute protocolName : WirelessProtocolName;
        attribute radioBand : RadioBand;
    }

    part def WirelessModule :> ElectronicsComponent {
        attribute moduleName : Name;
        port hostLink : ~UartPort;
        ref bleChannel : BleCommunicationChannel;
        ref wifiChannel : WiFiCommunicationChannel;
    }
}
