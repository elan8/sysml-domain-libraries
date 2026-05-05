package CommunicationCore {
    import SoftwareCore::*;
    import DistributedSystems::*;

    attribute def SessionName;
    attribute def OperationName;
    attribute def ContractName;

    part def CommunicationService :> Service;

    part def CommunicationEndpoint {
        attribute protocol : ProtocolName;
        attribute path : PathString;
        attribute port : PortNumber;
    }

    part def CommunicationChannel {
        attribute channelName : Name;
    }

    part def CommunicationBinding {
        attribute bindingName : Name;
    }

    part def CommunicationSession {
        attribute sessionName : SessionName;
    }

    part def CommunicationOperation {
        attribute operationName : OperationName;
    }

    part def OperationContract {
        attribute contractName : ContractName;
    }

    part def InputContract :> OperationContract;
    part def OutputContract :> OperationContract;
    part def ErrorContract :> OperationContract;
}
