package Elan8 {
    package Communication {
        package Kafka {
            import Elan8::Core::Name;
            import Elan8::Software::Core::*;
            import Elan8::Communication::Messaging::*;
            import Elan8::Communication::Serialization::*;

            attribute def PartitionCount;

            part def KafkaTopic :> EventStream {
                attribute partitions : PartitionCount;
            }

            part def KafkaConsumerGroup {
                attribute groupName : Name;
            }

            part def KafkaBinding :> MessageBinding;
        }
    }
}
