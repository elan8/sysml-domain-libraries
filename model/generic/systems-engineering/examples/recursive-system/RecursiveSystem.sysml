package RecursiveSystemExample {
    private import Elan8::SystemsEngineering::*;

    part def DriveSpecification :> SystemSpecification;
    part def DriveArchitecture :> DriveSpecification, SystemArchitecture;

    part def TransportSpecification :> SystemSpecification;
    part def TransportArchitecture :> TransportSpecification, SystemArchitecture {
        part drive : DriveSpecification;
    }
    part def TransportIntegration :> TransportArchitecture, SystemIntegration {
        part redefines drive : DriveArchitecture;
    }

    part def MachineSpecification :> SystemSpecification;
    part def MachineArchitecture :> MachineSpecification, SystemArchitecture {
        part transport : TransportSpecification;
    }
    part def MachineIntegration :> MachineArchitecture, SystemIntegration {
        part redefines transport : TransportIntegration;
    }
    part selectedMachine : MachineIntegration;
    doc /* Two recursive selections; drive is a leaf architecture. This fixture
         * demonstrates type relationships, not a complete product contract or
         * evidence of interface, behavioral or quantitative compatibility. */
}
