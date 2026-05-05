package MutatingOperationMissingSafetyExample {
    import SoftwareCore::*;
    import CommunicationCore::*;
    import SerializationDomain::*;

    part unsafeAutomationServer : SoftwareComponent;

    interface directWorkspaceEdit : MutatingInterface {
        attribute :>> effectKind = "mutating";
    }

    part directWorkspaceEditOperation : CommunicationOperation {
        attribute :>> operationName = "direct workspace edit";
    }

    part editInput : SerializedInputContract {
        attribute :>> contractName = "edit request";
        item :>> payload : JsonPayload {
            attribute :>> mediaType = "application/json";
            attribute :>> schema = "EditRequest";
        }
    }

    part editOutput : SerializedOutputContract {
        attribute :>> contractName = "edit result";
        item :>> payload : JsonPayload {
            attribute :>> mediaType = "application/json";
            attribute :>> schema = "EditResult";
        }
    }

    part editError : SerializedErrorContract {
        attribute :>> contractName = "edit error";
        item :>> payload : JsonPayload {
            attribute :>> mediaType = "application/json";
            attribute :>> schema = "EditError";
        }
    }
}
