package WirelessDomain {
    import CommunicationCore::*;
    import ElectronicsCore::*;
    import ElectronicsInterconnection::*;
    import SoftwareCore::*;

    part def WirelessModule :> ElectronicsComponent {
        port hostLink : SerialCommunicationPort;
        ref wirelessChannel : WirelessCommunicationChannel;
    }
}