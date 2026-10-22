package GrpcServices {
    private import ScalarValues::*;
    private import Elan8::Software::*;
    private import Elan8::Software::Bindings::*;
    private import Elan8::Generation::*;
    private import StandardViewDefinitions::*;

    item def GetStatusRequest;
    item def RobotStatus { attribute cleaning : Boolean; }
    item def StartCleaningRequest;
    item def StartCleaningResult { attribute accepted : Boolean; }
    item def GetDiagnosticsRequest;
    item def Diagnostics { attribute healthy : Boolean; }

    action def GetStatus :> QueryOperation {
        @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
        in request : GetStatusRequest;
        out response : RobotStatus;
    }
    action def StartCleaning :> CommandOperation {
        @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
        in request : StartCleaningRequest;
        out response : StartCleaningResult;
    }
    action def GetDiagnostics :> QueryOperation {
        @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
        in request : GetDiagnosticsRequest;
        out response : Diagnostics;
    }

    port def RobotControlService :> InteractionPort {
        @InterfaceSpec {
            uri = "model/technical/software/examples/interactions/robot.proto";
            format = SpecificationFormat::protobuf;
        }
        // Provider-side convention: incoming references to logical call performances.
        in ref action getStatus : GetStatus[0..*];
        in ref action startCleaning : StartCleaning[0..*];
    }
    port def DiagnosticsService :> InteractionPort {
        in ref action getDiagnostics : GetDiagnostics[0..*];
    }
    port def GrpcEndpoint :> InteractionPort {
        port robotControl : RobotControlService;
        port diagnostics : DiagnosticsService;
    }
    port def GrpcClientEndpoint :> InteractionPort {
        // Make the service-level conjugation explicit within this aggregate.
        port robotControl : ~RobotControlService;
        port diagnostics : ~DiagnosticsService;
    }

    part def RobotHandler :> SoftwareModule {
        action getStatus : GetStatus[0..*];
        action startCleaning : StartCleaning[0..*];
        action getDiagnostics : GetDiagnostics[0..*];
    }

    // A separate unary transport abstraction, not a complete HTTP/2 wire model.
    item def Http2Request {
        attribute path : String;
        attribute contentType : String;
    }
    item def Http2Response {
        attribute httpStatus : Integer;
        attribute grpcStatus : Integer;
    }
    port def UnaryHttp2Endpoint :> RequestReplyPort {
        in item :>> request : Http2Request;
        out item :>> reply : Http2Response;
    }

    part def ServerApplication :> SoftwareApplication {
        port grpc : GrpcEndpoint;
        port http2 : UnaryHttp2Endpoint;
        part handler : RobotHandler;
        bind grpc.robotControl.getStatus = handler.getStatus;
        bind grpc.robotControl.startCleaning = handler.startCleaning;
        bind grpc.diagnostics.getDiagnostics = handler.getDiagnostics;
        // Documented mapping convention: the logical endpoint uses this transport.
        // This is neither a binding of different values nor generated encoding behavior.
        allocate grpc to http2;
    }
    part def ClientApplication :> SoftwareApplication {
        port grpc : GrpcClientEndpoint;
        port http2 : ~UnaryHttp2Endpoint;
        allocate grpc to http2;
    }
    part system {
        part client : ClientApplication;
        part server : ServerApplication;
        // Two abstraction views of the interaction, not two independent calls.
        connect client.grpc.robotControl to server.grpc.robotControl;
        connect client.grpc.diagnostics to server.grpc.diagnostics;
        connect client.http2 to server.http2;
    }

    view services : GeneralView { expose system; }
}
