package Elan8 {
    package Examples {
        package Software {
            package WebShop {
                package Sequence {
                    import Elan8::Software::Core::*;
                    import Elan8::Software::Distributed::*;
                    import Elan8::Software::Interactions::*;

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
            }
        }
    }
}
