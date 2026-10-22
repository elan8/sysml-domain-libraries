package GrpcServices {
    private import ScalarValues::*;
    private import Elan8::Software::*;
    private import Elan8::Software::Bindings::*;
    private import Elan8::Generation::*;
    private import StandardViewDefinitions::*;

    // Project-local endpoint roles; these are not action/data directions.
    enum def EndpointRole { client; server; }
    metadata def GrpcEndpointRole {
        :> annotatedElement : SysML::PortUsage;
        attribute role : EndpointRole;
    }

    // Protobuf message schemas describe structured values, not occurrences.
    attribute def GetStatusRequestData;
    attribute def PositionData {
        attribute x : Real;
        attribute y : Real;
    }
    attribute def RobotStatusData {
        attribute cleaning : Boolean;
        attribute position : PositionData[0..1];
    }
    attribute def StartCleaningRequestData;
    attribute def StartCleaningResultData { attribute accepted : Boolean; }
    attribute def GetDiagnosticsRequestData;
    attribute def DiagnosticsData { attribute healthy : Boolean; }

    action def GetStatus :> QueryOperation {
        @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
        in attribute request : GetStatusRequestData;
        out attribute response : RobotStatusData;
    }
    action def StartCleaning :> CommandOperation {
        @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
        in attribute request : StartCleaningRequestData;
        out attribute response : StartCleaningResultData;
    }
    action def GetDiagnostics :> QueryOperation {
        @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
        in attribute request : GetDiagnosticsRequestData;
        out attribute response : DiagnosticsData;
    }

    port def RobotControlService :> InteractionPort {
        @InterfaceSpec {
            uri = "model/technical/software/examples/interactions/robot.proto";
            format = SpecificationFormat::protobuf;
        }
        // Undirected references group RPC contracts, independently of endpoint role.
        ref action getStatus : GetStatus[0..*];
        ref action startCleaning : StartCleaning[0..*];
    }
    port def DiagnosticsService :> InteractionPort {
        ref action getDiagnostics : GetDiagnostics[0..*];
    }
    port def GrpcEndpoint :> InteractionPort {
        port robotControl : RobotControlService;
        port diagnostics : DiagnosticsService;
    }
    part def RobotHandler :> SoftwareModule {
        action getStatus : GetStatus[0..*];
        action startCleaning : StartCleaning[0..*];
        action getDiagnostics : GetDiagnostics[0..*];
    }

    // Item-oriented request/response occurrences at a separate transport boundary.
    // Their identity/lifetime can matter independently of the RPC data values.
    // This is not a complete HTTP/2 wire model.
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
        port grpc : GrpcEndpoint {
            @GrpcEndpointRole { role = EndpointRole::server; }
        }
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
        port grpc : GrpcEndpoint {
            @GrpcEndpointRole { role = EndpointRole::client; }
        }
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
