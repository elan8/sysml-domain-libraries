package Bindings {
    doc /*
     * Technology choices for generic software elements. Each binding is
     * metadata on an operation, payload, port or component and carries only
     * the parameters a generator or deployment tool needs. The technology's
     * own specification (a .proto, an OpenAPI or AsyncAPI document, a CAN
     * DBC) is referenced with Elan8::Generation::InterfaceSpec rather than
     * re-modelled. Write a binding in the body of the element it applies to:
     *     action def GetQuote { @Rpc { protocol = RpcProtocol::grpc; } }
     */
    private import ScalarValues::*;

    enum def RpcProtocol {
        grpc;
        jsonRpc;
        thrift;
    }

    enum def StreamingKind {
        unary;
        serverStreaming;
        clientStreaming;
        bidirectional;
    }

    metadata def Rpc {
        doc /* The operation is offered as a remote procedure call. */
        :> annotatedElement : SysML::ActionDefinition;
        :> annotatedElement : SysML::ActionUsage;
        attribute protocol : RpcProtocol;
        attribute streaming : StreamingKind[0..1];
    }

    enum def HttpMethod {
        get;
        head;
        post;
        put;
        patch;
        delete;
    }

    metadata def HttpRoute {
        doc /*
         * The operation is offered as an HTTP route. A `get` or `head` route must
         * bind a QueryOperation.
         */
        :> annotatedElement : SysML::ActionDefinition;
        :> annotatedElement : SysML::ActionUsage;
        attribute method : HttpMethod;
        attribute path : String;
    }

    enum def BrokerKind {
        kafka;
        mqtt;
        amqp;
        nats;
        dds;
    }

    metadata def Topic {
        doc /*
         * Messages of the annotated payload or port travel over a broker topic.
         * Delivery is at least once unless stated otherwise, so a command sent
         * this way should be idempotent or deduplicated by the receiver.
         */
        :> annotatedElement : SysML::ItemDefinition;
        :> annotatedElement : SysML::PortUsage;
        attribute broker : BrokerKind;
        attribute topicName : String;
        attribute key : String[0..1] {
            doc /* The payload feature, by name, used as the partitioning key. */
        }
    }

    metadata def CanFrame {
        doc /* The annotated payload is carried in a CAN frame. */
        :> annotatedElement : SysML::ItemDefinition;
        attribute frameId : Natural;
        attribute extendedId : Boolean[0..1];
    }

    metadata def Container {
        doc /* The annotated component is deployed as a container image. */
        :> annotatedElement : SysML::PartDefinition;
        :> annotatedElement : SysML::PartUsage;
        attribute image : String;
        attribute replicas : Natural[0..1];
    }
}
