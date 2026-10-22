package KafkaEvents {
    private import ScalarValues::*;
    private import Elan8::Software::*;
    private import Elan8::Software::Bindings::*;
    private import StandardViewDefinitions::*;

    item def RobotStatusChanged {
        attribute robotId : String;
        attribute cleaning : Boolean;
    }
    port def RobotEvents :> MessagePort {
        out item :>> payload : RobotStatusChanged;
    }
    part def RobotPublisher :> SoftwareModule {
        port events : RobotEvents {
            @Topic { broker = BrokerKind::kafka; topicName = "robot.status"; key = "robotId"; }
        }
    }
    part def StatusMonitor :> SoftwareModule {
        // Project-local consumer configuration, not a generic library binding.
        attribute consumerGroup : String = "monitoring";
        port events : ~RobotEvents;
    }
    part def AuditRecorder :> SoftwareModule {
        attribute consumerGroup : String = "auditing";
        port events : ~RobotEvents;
    }
    part def TopicLog :> SoftwareDataStore {
        attribute :>> persistence = DataStorePersistence::persistent;
        item records : RobotStatusChanged[0..*];
    }
    part def KafkaCluster :> SoftwareComponent {
        @External;
        port incoming : ~RobotEvents;
        port monitoring : RobotEvents;
        port auditing : RobotEvents;
        part topicLog : TopicLog;
        doc /* External broker/log boundary. Ports abstract delivery to two classic
             * consumer groups, not Kafka's network protocol or polling API.
             * Offsets, partitions, retention, failures and actual delivery behavior
             * are intentionally not implemented by these connections. */
    }
    part system {
        part publisher : RobotPublisher;
        part kafka : KafkaCluster;
        part monitor : StatusMonitor;
        part audit : AuditRecorder;
        connect publisher.events to kafka.incoming;
        connect kafka.monitoring to monitor.events;
        connect kafka.auditing to audit.events;
    }
    view eventDelivery : GeneralView { expose system; }
}
