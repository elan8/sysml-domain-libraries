package CloudRuntimeDomain {
    import Core::*;
    import SoftwareCore::*;
    import SoftwareControlPlane::*;

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

    part def RuntimeWorkload :> ArtifactReference;

    part def ManagedService {
        attribute name : Name;
        attribute serviceUri : UriString;
    }
}
