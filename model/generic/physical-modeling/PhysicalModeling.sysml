package PhysicalModeling {
    doc /*
     * Links a part definition to an external dynamic model, either a Modelica
     * class or an FMI Functional Mock-up Unit (FMU). The SysML part stays the
     * system-model identity; the linked artifact is what a simulation tool
     * executes.
     *
     * A simulation run is an analysis case specializing SimulationScenario:
     * inputs are `in` parameters, signals to trace are `out` parameters, and
     * the time horizon and solver are attributes of the case. This library
     * does not encode constitutive equations or assemble a DAE.
     */

    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Parts::*;

    enum def FmuKind {
        doc /* FMI interface kind of the linked FMU. */
        modelExchange;
        coSimulation;
        scheduledExecution;
    }

    metadata def ModelicaModel {
        doc /*
         * Binds a part definition to a Modelica class. `className` is the
         * fully qualified class; `resourceUri` locates the .mo file or package.
         */
        :> annotatedElement : SysML::PartDefinition;
        attribute resourceUri : String;
        attribute className : String;
    }

    metadata def FmuModel {
        doc /*
         * Binds a part definition to an FMU. `resourceUri` locates the .fmu.
         * `modelIdentifier` and `fmiVersion` repeat the modelDescription fields
         * a tool would otherwise read from the file.
         */
        :> annotatedElement : SysML::PartDefinition;
        attribute resourceUri : String;
        attribute fmuKind : FmuKind;
        attribute modelIdentifier : String[0..1];
        attribute fmiVersion : String[0..1];
    }

    metadata def ExternalVariable {
        doc /*
         * Modelica component variable or FMU scalar-variable name for the
         * annotated feature. Omit when that name is already the SysML feature
         * name. Used on the `in` and `out` parameters of a SimulationScenario.
         */
        attribute variableName : String;
    }

    metadata def TimeSeriesInput {
        doc /*
         * Time-series file that drives the annotated scenario input, instead
         * of a single constant value.
         */
        attribute resourceUri : String;
    }

    attribute def SolverSelection {
        doc /*
         * Integrator for a Modelica model or an FMI Model Exchange FMU.
         * `name` is the identifier the target tool accepts, for example
         * "dassl", "ida", "cvode", or "euler". Co-simulation uses
         * SimulationScenario::communicationStep and may leave this unset.
         */
        attribute name : String;
        attribute relativeTolerance : Real[0..1];
        attribute absoluteTolerance : Real[0..1];
        attribute fixedStep : DurationValue[0..1];
    }

    analysis def SimulationScenario {
        doc /*
         * One simulation run of the subject part. The subject's behavior is
         * the Modelica class or FMU linked on its part definition.
         *
         * Specialize this definition to bind the subject, set the time horizon
         * and solver, declare `in` parameters for inputs, and declare `out`
         * parameters for signals to trace. A specialization may add an
         * objective when the run is also a pass/fail check.
         */
        subject simulatedSystem : Part;

        attribute startTime : DurationValue = 0 [s];
        attribute stopTime : DurationValue;
        attribute outputInterval : DurationValue[0..1];
        attribute communicationStep : DurationValue[0..1];
        attribute solver : SolverSelection[0..1];
    }
}
