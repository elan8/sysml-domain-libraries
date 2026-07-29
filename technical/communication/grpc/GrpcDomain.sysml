package Elan8 {
    package Communication {
        package Grpc {
            import Elan8::Communication::Core::*;
            import Elan8::Communication::Serialization::*;

            attribute def MethodName;

            part def GrpcService :> CommunicationService;

            part def GrpcMethod :> CommunicationOperation {
                attribute methodName : MethodName;
            }

            part def UnaryRpc :> GrpcMethod;
            part def ServerStreamingRpc :> GrpcMethod;
            part def ClientStreamingRpc :> GrpcMethod;
            part def BidirectionalStreamingRpc :> GrpcMethod;

            item def GrpcRequest :> ProtobufMessage;
            item def GrpcResponse :> ProtobufMessage;
        }
    }
}
