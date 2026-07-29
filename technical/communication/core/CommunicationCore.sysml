package CommunicationCore {
    import Core::*;

    attribute def Hostname;
    attribute def PortNumber;
    attribute def ProtocolName;
    attribute def UriString;


    part def CommunicationEndpoint {
        attribute protocol : ProtocolName;
        attribute port : PortNumber;
    }

    part def CommunicationChannel {
        attribute name : Name;
    }

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
