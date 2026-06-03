package MinimalTraceabilityExample {
    import RequirementManagement::*;

    part def DeliverySystem {
        attribute systemName : Name;
    }

    part notificationService : DeliverySystem {
        attribute :>> systemName = "notification-service";
    }

    requirement notifyCustomer : UserRequirement {
        attribute :>> requirementId = "USR-001";
        attribute :>> status = RequirementStatusKind::approved;
        doc /* Customers shall be notified when an order changes state. */
    }

    requirement sendOrderUpdate : FunctionalRequirement {
        attribute :>> requirementId = "SYS-001";
        attribute :>> status = RequirementStatusKind::approved;
        doc /* The delivery system shall send an order update notification after state changes. */
    }

    #derivation connection {
        end #original ::> notifyCustomer;
        end #derive ::> sendOrderUpdate;
    }

    satisfy sendOrderUpdate by notificationService;

    verification verifyOrderUpdateNotification : VerificationCase {
        attribute :>> caseName = "verify-order-update-notification";
        attribute :>> method = "integration-test";
        subject systemUnderTest : DeliverySystem;
        objective {
            verify sendOrderUpdate;
        }
    }
}
