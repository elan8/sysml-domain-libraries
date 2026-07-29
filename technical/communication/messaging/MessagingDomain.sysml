package Elan8 {
    package Communication {
        package Messaging {
            import Elan8::Communication::Core::*;
            import Elan8::Core::*;
            import Elan8::Software::Distributed::*;
            import Elan8::Communication::Serialization::*;

            attribute def DeliveryGuarantee;
            attribute def RetentionPolicy;

            part def MessageChannel :> CommunicationChannel;

            part def EventStream :> MessageChannel {
                attribute retention : RetentionPolicy;
            }

            part def Queue {
                attribute queueName : Name;
            }

            part def Publisher {
                attribute publisherName : Name;
            }

            part def Consumer {
                attribute consumerName : Name;
            }

            part def MessageBinding :> CommunicationBinding {
                attribute deliveryGuarantee : DeliveryGuarantee;
            }

            item def StreamEvent :> Event;
        }
    }
}
