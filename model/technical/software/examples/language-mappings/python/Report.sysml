package PythonMapping {
    private import ScalarValues::*;
    private import Elan8::Software::*;
    private import Elan8::Generation::*;

    // A namespace for source-module contents, not a runtime component instance.
    package ReportModule {
        @SourceCode {
            path = "model/technical/software/examples/language-mappings/python/report.py";
            codeLanguage = ProgrammingLanguage::python;
        }
        action def FormatReport :> QueryOperation {
            in label : String;
            out report : String;
        }
        action def RunReport :> CommandOperation {
            @SourceCode {
                path = "model/technical/software/examples/language-mappings/python/report.py";
                codeLanguage = ProgrammingLanguage::python;
                entryPoint = "main";
            }
            in label : String;
            out exitCode : Integer;
        }
    }
    part def ReportApplication :> SoftwareApplication {
        action main : ReportModule::RunReport;
    }
    part application : ReportApplication;
    part pythonRuntime : ExecutionPlatform;
    allocate application to pythonRuntime;
}
