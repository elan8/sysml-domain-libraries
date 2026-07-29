package Elan8 {
    package Examples {
        package Software {
            package WebShop {
                import Elan8::Examples::Software::WebShop::Architecture::*;
                import Elan8::Examples::Software::WebShop::Requirements::*;
                import Elan8::Examples::Software::WebShop::Behavior::*;
                import Elan8::Software::Platform::Kubernetes::*;

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
        }
    }
}
