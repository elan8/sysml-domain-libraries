package MissingVerificationExample {
    import RequirementManagement::*;

    part def DeliverySystem {
        attribute systemName : Name;
    }

    part notificationService : DeliverySystem {
        attribute :>> systemName = "notification-service";
    }

    requirement notifyCustomer : UserRequirement {
        attribute :>> requirementId = "USR-002";
        attribute :>> status = RequirementStatusKind::approved;
        doc /* Customers shall receive timely order-state notifications. */
    }

    requirement sendOrderUpdate : FunctionalRequirement {
        attribute :>> requirementId = "SYS-002";
        attribute :>> status = RequirementStatusKind::approved;
        doc /* The delivery system shall publish notification events for order-state changes. */
    }

    #derivation connection {
        end #original ::> notifyCustomer;
        end #derive ::> sendOrderUpdate;
    }

    satisfy sendOrderUpdate by notificationService;
}
