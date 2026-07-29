package PrintedCircuitBoardAssemblyExample {
    private import ElectronicsAssemblyDomain::*;
    private import ElectronicComponentDomain::*;
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;
    private import PrintedBoardDomain::*;

    part def ControllerBoard :> PrintedCircuitBoard;
    part def Controller :> IntegratedCircuit;

    part def ControllerBoardAssembly :> PrintedCircuitBoardAssembly {
        part bareBoard : ControllerBoard :>> bareBoard;
        part controller : Controller :> mountedComponents;
        part decouplingCapacitor : CeramicCapacitor :> mountedComponents;
        part externalConnector : BoardConnector :> mountedComponents;
    }
}
