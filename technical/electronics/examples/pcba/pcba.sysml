package Elan8 {
    package Examples {
        package Electronics {
            package Pcba {
                private import Elan8::Electronics::Assembly::*;
                private import Elan8::Electronics::Components::*;
                private import Elan8::Electronics::Core::*;
                private import Elan8::Electronics::Interconnection::*;
                private import Elan8::Electronics::Board::*;

                part def ControllerBoard :> PrintedCircuitBoard;
                part def Controller :> IntegratedCircuit;

                part def ControllerBoardAssembly :> PrintedCircuitBoardAssembly {
                    part bareBoard : ControllerBoard :>> bareBoard;
                    part controller : Controller :> mountedComponents;
                    part decouplingCapacitor : CeramicCapacitor :> mountedComponents;
                    part externalConnector : BoardConnector :> mountedComponents;
                }
            }
        }
    }
}
