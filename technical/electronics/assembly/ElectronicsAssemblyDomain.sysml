package Elan8 {
    package Electronics {
        package Assembly {
            private import Elan8::Core::*;
            private import Elan8::Electronics::Core::*;
            private import Elan8::Electronics::Interconnection::*;
            private import Elan8::Electronics::Board::*;
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
    }
}
