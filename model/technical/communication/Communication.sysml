package Communication {
    package Core {
        private import Elan8::Core::*;

        attribute def Hostname;
        attribute def PortNumber;
        attribute def ProtocolName;
        attribute def UriString;


        part def CommunicationEndpoint {
            attribute protocol : ProtocolName;
            attribute portNumber : PortNumber;
        }

        part def CommunicationChannel {
            attribute name : Name;
        }

        part def CommunicationService;

        part def CommunicationBinding {
            attribute name : Name;
            ref endpoint : CommunicationEndpoint;
            ref channel : CommunicationChannel;
            ref session : CommunicationSession;
            ref operation : CommunicationOperation;
        }

        part def CommunicationSession {
            attribute name : Name;
        }

        part def CommunicationOperation {
            attribute name : Name;
        }

        part def OperationContract {
            attribute name : Name;
        }

        part def InputContract :> OperationContract;
        part def OutputContract :> OperationContract;
        part def ErrorContract :> OperationContract;
    }
    public import DeviceBus;
    public import Grpc;
    public import Http;
    public import Industrial;
    public import Kafka;
    public import Messaging;
    public import OpenApi;
    public import Serialization;
    public import Transport;
    package Wireless {
        private import Elan8::Communication::Core::*;
        private import Elan8::Electronics::Core::*;
        private import Elan8::Electronics::Interconnection::*;
        private import Elan8::Software::Core::*;

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
