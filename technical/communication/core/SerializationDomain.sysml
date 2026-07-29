package Elan8 {
    package Communication {
        package Serialization {
            import Elan8::Software::Core::*;
            import Elan8::Software::Distributed::*;
            import Elan8::Communication::Core::*;

            attribute def MediaType;
            attribute def SchemaReference;
            attribute def PackageName;

            item def SerializedPayload :> MessageType {
                attribute mediaType : MediaType;
                attribute schema : SchemaReference;
            }

            item def JsonPayload :> SerializedPayload;
            item def XmlPayload :> SerializedPayload;
            item def ProtobufMessage :> SerializedPayload {
                attribute packageName : PackageName;
            }

            part def SerializedOperationContract :> OperationContract {
                item payload : SerializedPayload;
            }

            part def SerializedInputContract :> InputContract {
                item payload : SerializedPayload;
            }

            part def SerializedOutputContract :> OutputContract {
                item payload : SerializedPayload;
            }

            part def SerializedErrorContract :> ErrorContract {
                item payload : SerializedPayload;
            }
        }
    }
}
