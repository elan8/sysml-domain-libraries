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
        ref payload : JsonPayload;
    }

    part editOutput : SerializedOutputContract {
        attribute :>> contractName = "edit result";
        ref payload : JsonPayload;
    }

    part editError : SerializedErrorContract {
        attribute :>> contractName = "edit error";
        ref payload : JsonPayload;
    }
}
