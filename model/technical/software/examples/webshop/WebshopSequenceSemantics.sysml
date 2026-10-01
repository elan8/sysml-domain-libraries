package Sequence {
    private import Elan8::Software::Core::*;
    private import Elan8::Software::Distributed::*;
    private import Elan8::Software::Interactions::*;

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
