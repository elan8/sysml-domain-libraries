package WebShop {
    doc /*
     * A checkout service built from Elan8::Software. It demonstrates queries
     * and commands, request-reply and one-way ports, technology bindings, an
     * implemented state machine, a code generation view and a formally
     * verified requirement.
     * Request, reply and event types here describe message occurrences for the
     * item-oriented ports. For pure structured payload schemas and attribute-
     * valued RPC parameters, see the GrpcServices example.
     */
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Units::Engineering::*;
    private import Elan8::Software::*;
    private import Elan8::Software::Bindings::*;
    private import Elan8::Generation::*;

    // Payloads
    attribute def OrderId :> String;
    item def CartLine { attribute sku : String; attribute quantity : Natural; }
    item def PlaceOrderRequest { item lines : CartLine[1..*]; }
    item def OrderConfirmation { attribute orderId : OrderId; }
    item def OrderStatusRequest { attribute orderId : OrderId; }
    item def OrderStatus { attribute orderId : OrderId; attribute paid : Boolean; }
    item def PaymentRequest { attribute orderId : OrderId; attribute amountCents : Natural; }
    item def PaymentResult { attribute approved : Boolean; }

    item def OrderPlaced {
        doc /* Published once per accepted order. */
        @Topic { broker = BrokerKind::kafka; topicName = "orders.placed"; key = "orderId"; }
        attribute orderId : OrderId;
    }

    // Interfaces: each specialises an interaction kind and redefines its payloads.
    port def CheckoutApi :> RequestReplyPort {
        in item :>> request : PlaceOrderRequest;
        out item :>> reply : OrderConfirmation;
    }
    port def OrderQueryApi :> RequestReplyPort {
        in item :>> request : OrderStatusRequest;
        out item :>> reply : OrderStatus;
    }
    port def PaymentApi :> RequestReplyPort {
        in item :>> request : PaymentRequest;
        out item :>> reply : PaymentResult;
    }
    port def OrderEvents :> MessagePort {
        out item :>> payload : OrderPlaced;
    }

    #software part def CheckoutService {
        doc /* Accepts orders, has them paid and publishes OrderPlaced. */
        @Container { image = "registry.example.com/webshop/checkout:1.4"; replicas = 3; }
        @SourceCode { path = "services/checkout"; codeLanguage = ProgrammingLanguage::typeScript; }

        port checkout : CheckoutApi;
        port orderQueries : OrderQueryApi;
        port payments : ~PaymentApi;
        port events : OrderEvents;

        #command action placeOrder {
            in request : PlaceOrderRequest;
            out confirmation : OrderConfirmation;
            @HttpRoute { method = HttpMethod::post; path = "/orders"; }
        }

        #query action orderStatus {
            in request : OrderStatusRequest;
            out status : OrderStatus;
            @HttpRoute { method = HttpMethod::get; path = "/orders/{orderId}"; }
        }

        // The implemented behaviour: owned by a SoftwareComponent, so a generator produces it.
        state orderLifecycle {
            entry; then created;
            state created;
            transition first created then awaitingPayment;
            state awaitingPayment;
            transition first awaitingPayment then paid;
            transition first awaitingPayment then cancelled;
            state paid;
            state cancelled;
        }
    }

    #external #software part def PaymentProvider {
        doc /* A third-party payment service: not generated, its contract is an assumption. */
        port payments : PaymentApi;

        #command action authorize {
            in request : PaymentRequest;
            out result : PaymentResult;
            @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; }
            @Idempotent;
        }
    }

    part shop {
        part checkoutService : CheckoutService;
        part paymentProvider : PaymentProvider;
        connect checkoutService.payments to paymentProvider.payments;
    }

    requirement <'WS-001'> placedOrdersArePaidOrCancelled {
        doc /* An order that has been placed is eventually paid or cancelled. */
        subject service : CheckoutService;
    }

    verification def CheckoutLifecycleCheck {
        @FormalVerification { technique = VerificationTechnique::modelChecking; bound = 20; }
        subject service : CheckoutService;
        objective { verify placedOrdersArePaidOrCancelled; }
    }

    view checkoutCode : CodeGenerationView {
        doc /* Generates the checkout service: its operations, ports and order state machine. */
        @CodeGeneration { targetLanguage = ProgrammingLanguage::typeScript; stateMachineStyle = StateMachineStyle::statePattern; }
        expose CheckoutService;
    }
}
