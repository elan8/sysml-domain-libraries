package WebshopSequenceSemantics {
    import SoftwareCore::*;
    import DistributedSystems::*;
    import SoftwareInteractions::*;

    part def CommerceInteractionScenario :> InteractionScenario;

    part def ServiceLifeline :> Lifeline {
        ref service : Service;
    }

    part def TopicLifeline :> Lifeline {
        ref topic : Topic;
    }

    part def ExternalSystemLifeline :> Lifeline {
        ref externalSystem : ExternalSystem;
    }
}
