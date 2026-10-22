package RustMapping {
    private import ScalarValues::*;
    private import Elan8::Software::*;
    private import Elan8::Generation::*;

    // The crate's namespace is distinct from its Cargo package and build artifact.
    package CounterCrate {
        @SourceCode {
            path = "model/technical/software/examples/language-mappings/rust/src/lib.rs";
            codeLanguage = ProgrammingLanguage::rust;
        }
        package Arithmetic {
            action def Double :> QueryOperation {
                @SourceCode {
                    path = "model/technical/software/examples/language-mappings/rust/src/arithmetic.rs";
                    codeLanguage = ProgrammingLanguage::rust;
                }
                in value : Integer;
                out doubled : Integer;
            }
        }
        action def ReadCounter :> QueryOperation {
            out value : Integer;
        }
        action def AddToCounter :> CommandOperation {
            in amount : Integer;
        }
        part def Counter :> SoftwareModule {
            private attribute value : Integer = 0;
            action read : ReadCounter;
            action add : AddToCounter;
        }
    }
    part def CounterApplication :> SoftwareApplication {
        part counter : CounterCrate::Counter;
    }
    part application : CounterApplication;
}
