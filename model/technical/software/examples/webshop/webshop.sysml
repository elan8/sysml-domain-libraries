package WebShop {
    public import Architecture;
    public import Behavior;
    package Requirements {
        private import Examples::Software::WebShop::Architecture::*;

        requirement def CheckoutLatencyReq {
            subject checkoutService : CheckoutService;
            doc /* The checkout path shall keep p95 end-user latency below 300 ms. */
            require constraint { doc /* p95 create-order latency remains within target. */ }
        }

        requirement def CheckoutAvailabilityReq {
            subject apiGateway : ApiGateway;
            doc /* The public checkout API shall maintain at least 99.95% monthly availability. */
            require constraint { doc /* Availability budget for checkout stays above SLO. */ }
        }

        requirement def PaymentReliabilityReq {
            subject paymentsService : PaymentsService;
            doc /* Payment authorization calls shall meet the business reliability objective. */
            require constraint { doc /* Payment authorization success rate remains in target range. */ }
        }

        requirement def EventDurabilityReq {
            subject ordersEventsTopic : OrdersEventsTopic;
            doc /* Order events shall be retained for replay and incident recovery. */
            require constraint { doc /* Topic retention remains at least seven days. */ }
        }

        requirement def SecurityBoundaryReq {
            subject apiGateway : ApiGateway;
            doc /* Public traffic shall cross an explicit ingress boundary before business services. */
            require constraint { doc /* Only approved ingress paths expose checkout functionality. */ }
        }
    }
    public import Sequence;
    package Views {
        private import StandardViewDefinitions::*;
        private import Examples::Software::WebShop::Architecture::*;
        private import Examples::Software::WebShop::Behavior::*;
        private import Examples::Software::WebShop::Requirements::*;
        private import Examples::Software::WebShop::*;

        view structure : GeneralView {
            expose Examples::Software::WebShop::webshopSystem;
        }

        view connections : InterconnectionView {
            expose Examples::Software::WebShop::webshopSystem;
        }

        view checkoutFlow : SequenceView {
            expose Examples::Software::WebShop::Architecture::CheckoutFlow;
        }

        view orderEventFanout : SequenceView {
            expose Examples::Software::WebShop::Architecture::OrderEventFanout;
        }

        view orderLifecycle : StateTransitionView {
            expose Examples::Software::WebShop::Behavior::OrderLifecycleStateMachine;
        }

        view checkoutPipeline : ActionFlowView {
            expose Examples::Software::WebShop::Behavior::CheckoutPipeline;
        }

        view requirements : GeneralView {
            expose Examples::Software::WebShop::Requirements::CheckoutLatencyReq;
            expose Examples::Software::WebShop::Requirements::CheckoutAvailabilityReq;
            expose Examples::Software::WebShop::Requirements::PaymentReliabilityReq;
            expose Examples::Software::WebShop::Requirements::EventDurabilityReq;
            expose Examples::Software::WebShop::Requirements::SecurityBoundaryReq;
        }
    }
    private import Examples::Software::WebShop::Architecture::*;
    private import Examples::Software::WebShop::Requirements::*;
    private import Examples::Software::WebShop::Behavior::*;
    private import Elan8::Software::Platform::Kubernetes::*;

    part def CommerceCluster :> KubernetesCluster {
        attribute :>> clusterName = "commerce-prod";
        attribute :>> nodeName = "k8s-node-a";
        attribute :>> host = "k8s-node-a.internal";
    }

    part webshopSystem : WebShopSystem {
        exhibit state orderLifecycle : OrderLifecycleStateMachine;
        perform action checkoutPipeline : CheckoutPipeline;
    }
    part commerceCluster : CommerceCluster;

    requirement checkoutLatency : CheckoutLatencyReq;
    requirement checkoutAvailability : CheckoutAvailabilityReq;
    requirement paymentReliability : PaymentReliabilityReq;
    requirement eventDurability : EventDurabilityReq;
    requirement securityBoundary : SecurityBoundaryReq;

    satisfy checkoutLatency by webshopSystem.checkoutService;
    satisfy checkoutAvailability by webshopSystem.apiGateway;
    satisfy paymentReliability by webshopSystem.paymentsService;
    satisfy eventDurability by webshopSystem.ordersEventsTopic;
    satisfy securityBoundary by webshopSystem.apiGateway;

    allocate webshopSystem.checkoutService to commerceCluster;
}
