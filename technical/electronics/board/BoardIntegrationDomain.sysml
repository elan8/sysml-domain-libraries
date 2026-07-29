package BoardIntegrationDomain {
    import Core::*;
    import ElectronicsCore::*;
    import ElectricalPowerDomain::*;
    import EmbeddedComputeDomain::*;
    import ElectronicIoDomain::*;
    import ElectronicBusDomain::*;


    attribute def ConnectorType;
    attribute def LayerCount;

    part def Connector  {
        attribute connectorType : ConnectorType;
    }

    part def PrintedCircuitBoard  {
        attribute layerCount : LayerCount;
    }

    part def BoardAssembly :> ElectronicsComponent {
        port pcb: PrintedCircuitBoard;
    }

    part def BoardConnector :> Connector ;     
    part def WiringHarness ;

}
