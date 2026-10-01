package Messaging {
    private import Elan8::Communication::Core::*;
    private import Elan8::Core::*;
    private import Elan8::Software::Distributed::*;
    private import Elan8::Communication::Serialization::*;

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
