package Transport {
    private import Elan8::Communication::Core::*;

    attribute def ReliabilityMode;

    part def TransportLink :> CommunicationChannel {
        attribute reliability : ReliabilityMode;
    }

    part def TcpTransport :> TransportLink;
    part def UdpTransport :> TransportLink;
}
