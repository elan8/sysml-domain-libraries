package MissingVerificationExample {
    import RequirementManagement::*;
    import RequirementMetadata::*;
    import ModelingMetadata::*;

    part def DeliverySystem {
        attribute systemName : Name;
    }

    part notificationService : DeliverySystem {
        attribute :>> systemName = "notification-service";
    }

    requirement notifyCustomer {
        @RequirementRole { role = user; }
        @RequirementIdentity { requirementId = "USR-002"; }
        @StatusInfo { status = done; }
        doc /* Customers shall receive timely order-state notifications. */
    }

    requirement sendOrderUpdate {
        @RequirementRole { role = functional; }
        @RequirementIdentity { requirementId = "SYS-002"; }
        @StatusInfo { status = done; }
        doc /* The delivery system shall publish notification events for order-state changes. */
    }

    #derivation connection {
        end #original ::> notifyCustomer;
        end #derive ::> sendOrderUpdate;
    }

    satisfy sendOrderUpdate by notificationService;
}
