package Elan8 {
    package Software {
        package Platform {
            package Cloud {
                import Elan8::Core::*;
                private import Elan8::Communication::Core::UriString;
                import Elan8::Software::Core::*;

                attribute def RegionName;
                attribute def ZoneName;
                attribute def ResourceClass;

                part def CloudRegion {
                    attribute name : RegionName;
                }

                part def CloudZone {
                    attribute name : ZoneName;
                }

                part def RuntimeCluster {
                    attribute name : Name;
                    attribute resourceClass : ResourceClass;
                }

                part def RuntimeWorkload :> DeployableComponent;

                part def ManagedService {
                    attribute name : Name;
                    attribute serviceUri : UriString;
                }
            }
        }
    }
}
