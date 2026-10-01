package Kafka {
    private import Elan8::Core::Name;
    private import Elan8::Software::Core::*;
    private import Elan8::Communication::Messaging::*;
    private import Elan8::Communication::Serialization::*;

    attribute def PartitionCount;

    part def KafkaTopic :> EventStream {
        attribute partitions : PartitionCount;
    }

    part def KafkaConsumerGroup {
        attribute groupName : Name;
    }

    part def KafkaBinding :> MessageBinding;
}
