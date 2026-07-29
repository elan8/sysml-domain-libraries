package WirelessDomain {
    import CommunicationCore::*;
    import ElectronicsCore::*;
    import ElectronicsInterconnection::*;
    import SoftwareCore::*;

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
