package Generation {
    doc /*
     * What a tool should produce from a model and how. A generation or
     * verification run is scoped by the model itself: a CodeGenerationView
     * selects elements with `expose` and `filter` (as a Doc42 document view
     * does), and a verification case names its subject and objective. Tool
     * options are metadata. Links to artifacts outside the model are
     * SourceCode and InterfaceSpec. See docs/library-design.md, section 4.
     */
    private import ScalarValues::*;

    enum def ProgrammingLanguage {
        c;
        cpp;
        rust;
        python;
        java;
        typeScript;
    }

    enum def StateMachineStyle {
        switchCase;
        stateTable;
        statePattern;
    }

    view def CodeGenerationView {
        doc /*
         * One code generation run. The view exposes what is generated; its
         * rendering is the generator. Annotate the view with CodeGeneration
         * to choose the language and style.
         */
    }

    metadata def CodeGeneration {
        doc /* Options for the code generation view it annotates. */
        :> annotatedElement : SysML::ViewUsage;
        attribute targetLanguage : ProgrammingLanguage;
        attribute stateMachineStyle : StateMachineStyle[0..1];
        attribute strictCommandQuerySeparation : Boolean[0..1];
    }

    enum def VerificationTechnique {
        modelChecking;
        theoremProving;
        abstractInterpretation;
    }

    metadata def FormalVerification {
        doc /*
         * The annotated verification case is discharged by a formal method:
         * its subject's state machines and contracts are checked against its
         * objective's requirements.
         */
        :> annotatedElement : SysML::VerificationCaseDefinition;
        :> annotatedElement : SysML::VerificationCaseUsage;
        attribute technique : VerificationTechnique;
        attribute bound : Natural[0..1] {
            doc /* Exploration depth for a bounded technique. */
        }
    }

    metadata def SourceCode {
        doc /* The annotated element is implemented by source code at `path`. */
        attribute path : String;
        attribute codeLanguage : ProgrammingLanguage[0..1];
        attribute entryPoint : String[0..1];
    }

    enum def SpecificationFormat {
        protobuf;
        openApi;
        asyncApi;
        canDbc;
        jsonSchema;
    }

    metadata def InterfaceSpec {
        doc /* The annotated port, interface or payload is specified by the document at `uri`. */
        attribute uri : String;
        attribute format : SpecificationFormat;
    }
}
