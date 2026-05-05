package Tool42SystemModel {
    import SoftwareCore::*;
    
    // Basics-first model: software structure hierarchy only.
    // This captures package and module decomposition from source.

    part def Tool42Codebase {
        part packageArtifact : SoftwarePackage {
            attribute packageName = "tool42";
            attribute version = "0.2.0";
        }

        part mcpModule : SoftwareModule {
            attribute moduleName = "mcp";
        }

        part coreModule : SoftwareModule {
            attribute moduleName = "core";
        }

        part refactorModule : SoftwareModule {
            attribute moduleName = "core::refactor";
        }

        part mainBinary : SoftwareModule {
            attribute moduleName = "main.rs";
        }
    }

    part def Tool42System {
        part codebase : Tool42Codebase;
    }

    part tool42 : Tool42System;

}
