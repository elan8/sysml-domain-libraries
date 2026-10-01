package MassSpringSimulation {
    doc /*
     * A mass-spring whose dynamics live in a Modelica class, plus a damper
     * linked as an FMU, and one simulation scenario: a fixed input mass and
     * a traced position over five seconds.
     */

    private import Elan8::PhysicalModeling::*;
    private import ISQ::*;
    private import SI::*;
    private import ScalarValues::*;

    part def MassSpring {
        doc /* Translational mass-spring. The Modelica class supplies the dynamics. */
        @ModelicaModel {
            resourceUri = "models/MassSpring.mo";
            className = "Example.MassSpring";
        }
        attribute mass : MassValue;
        attribute stiffness : Real;
        attribute position : LengthValue;
    }

    part def Damper {
        doc /* Linear damper supplied as an FMI co-simulation FMU. */
        @FmuModel {
            resourceUri = "models/Damper.fmu";
            fmuKind = FmuKind::coSimulation;
            modelIdentifier = "Damper";
            fmiVersion = "3.0";
        }
        attribute dampingCoefficient : Real;
        attribute velocity : SpeedValue;
    }

    analysis def MassSpringStep :> SimulationScenario {
        subject massSpring : MassSpring :>> simulatedSystem;

        attribute :>> stopTime = 5 [s];
        attribute :>> outputInterval = 0.01 [s];
        attribute :>> solver {
            :>> name = "dassl";
            :>> relativeTolerance = 0.000001;
        }

        in mass : MassValue = 1 [kg] {
            @ExternalVariable {
                variableName = "m";
            }
        }

        out position : LengthValue {
            @ExternalVariable {
                variableName = "s";
            }
        }
    }
}
