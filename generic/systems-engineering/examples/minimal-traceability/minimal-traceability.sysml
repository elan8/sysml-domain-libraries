package MinimalTraceabilityExample {
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
        @RequirementIdentity { requirementId = "USR-001"; }
        @StatusInfo { status = done; }
        doc /* Customers shall be notified when an order changes state. */
    }

    requirement sendOrderUpdate {
        @RequirementRole { role = functional; }
        @RequirementIdentity { requirementId = "SYS-001"; }
        @StatusInfo { status = done; }
        doc /* The delivery system shall send an order update notification after state changes. */
    }

    #derivation connection {
        end #original ::> notifyCustomer;
        end #derive ::> sendOrderUpdate;
    }

    satisfy sendOrderUpdate by notificationService;

    verification verifyOrderUpdateNotification {
        subject systemUnderTest : DeliverySystem;
        objective {
            verify sendOrderUpdate;
        }
    }
}
