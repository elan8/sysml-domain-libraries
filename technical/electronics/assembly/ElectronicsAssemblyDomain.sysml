package ElectronicsAssemblyDomain {
    private import Core::*;
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;
    private import PrintedBoardDomain::*;
    private import ScalarValues::*;

    enum def BoardSide {
        top;
        bottom;
    }

    enum def MountingTechnology {
        surfaceMount;
        throughHole;
        pressFit;
        mechanical;
    }

    attribute def ReferenceDesignator :> String;

    abstract part def ElectronicsAssembly :> ElectronicsComponent;

    part def PrintedCircuitBoardAssembly :> ElectronicsAssembly {
        part bareBoard : PrintedCircuitBoard;
        part mountedComponents : PhysicalComponent[0..*];
    }

    connection def BoardMounting {
        end board : PrintedCircuitBoard;
        end component : PhysicalComponent;
        attribute referenceDesignator : ReferenceDesignator;
        attribute side : BoardSide;
        attribute mountingTechnology : MountingTechnology;
    }

    part def ElectronicsModule :> ElectronicsAssembly {
        part circuitBoardAssemblies : PrintedCircuitBoardAssembly[1..*];
        part wiringHarnesses : WiringHarness[0..*];
    }

    part def BoxBuildAssembly :> ElectronicsAssembly {
        part modules : ElectronicsAssembly[1..*];
        part wiringHarnesses : WiringHarness[0..*];
    }
}
