package CSharpMapping {
    private import ScalarValues::*;
    private import Elan8::Software::*;
    private import Elan8::Generation::*;

    action def ReadCounter :> QueryOperation {
        out value : Integer;
    }
    action def AddToCounter :> CommandOperation {
        in amount : Integer;
    }
    part def CounterContract :> SoftwareServiceContract {
        action read : ReadCounter;
        action add : AddToCounter;
    }
    part def Counter :> SoftwareModule, CounterContract {
        @SourceCode {
            path = "model/technical/software/examples/language-mappings/csharp/Counter.cs";
            codeLanguage = ProgrammingLanguage::cSharp;
        }
        private attribute value : Integer = 0;
    }
    part def CounterApplication :> SoftwareApplication {
        part counter : Counter;
    }
    part application : CounterApplication;
}
