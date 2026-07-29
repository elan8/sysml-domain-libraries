package Elan8 {
    package Examples {
        package Software {
            package WebShop {
                package Views {
                    import Elan8::Examples::Software::WebShop::Architecture::*;
                    import Elan8::Examples::Software::WebShop::Behavior::*;
                    import Elan8::Examples::Software::WebShop::Requirements::*;
                    import Elan8::Examples::Software::WebShop::*;

                    view structure : GeneralView {
                        expose Elan8::Examples::Software::WebShop::webshopSystem;
                    }

                    view connections : InterconnectionView {
                        expose Elan8::Examples::Software::WebShop::webshopSystem;
                    }

                    view checkoutFlow : SequenceView {
                        expose Elan8::Examples::Software::WebShop::Architecture::CheckoutFlow;
                    }

                    view orderEventFanout : SequenceView {
                        expose Elan8::Examples::Software::WebShop::Architecture::OrderEventFanout;
                    }

                    view orderLifecycle : StateTransitionView {
                        expose Elan8::Examples::Software::WebShop::Behavior::OrderLifecycleStateMachine;
                    }

                    view checkoutPipeline : ActionFlowView {
                        expose Elan8::Examples::Software::WebShop::Behavior::CheckoutPipeline;
                    }

                    view requirements : GeneralView {
                        expose Elan8::Examples::Software::WebShop::Requirements::CheckoutLatencyReq;
                        expose Elan8::Examples::Software::WebShop::Requirements::CheckoutAvailabilityReq;
                        expose Elan8::Examples::Software::WebShop::Requirements::PaymentReliabilityReq;
                        expose Elan8::Examples::Software::WebShop::Requirements::EventDurabilityReq;
                        expose Elan8::Examples::Software::WebShop::Requirements::SecurityBoundaryReq;
                    }
                }
            }
        }
    }
}
