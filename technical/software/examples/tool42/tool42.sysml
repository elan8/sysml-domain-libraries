package Tool42SystemModel {
    import SoftwareCore::*;
    import DistributedSystems::*;
    import CommunicationCore::*;
    import SerializationDomain::*;
    import SoftwareControlPlane::*;
    import SoftwareDelivery::*;
    import ObservabilityDomain::*;
    import IdentitySecurityDomain::*;
    import SoftwareInteractions::*;

    part def Tool42Codebase {
        part serverPackage : SoftwarePackage {
            attribute :>> packageName = "tool42";
            attribute :>> version = "0.2.0";
        }

        part serverExecutable : ExecutableComponent {
            attribute :>> executableName = "tool42";
        }

        part sourceRepository : SourceRepository {
            attribute :>> repositoryName = "tool42";
            attribute :>> repositoryUrl = "https://github.com/elan8/tool42";
        }

        part mcpModule : SoftwareModule {
            attribute :>> moduleName = "mcp";
        }

        part coreModule : SoftwareModule {
            attribute :>> moduleName = "core";
        }

        part refactorModule : SoftwareModule {
            attribute :>> moduleName = "core::refactor";
        }

        part mainBinary : SoftwareModule {
            attribute :>> moduleName = "main.rs";
        }

        part serverEntrypointSource : SourceFile {
            attribute :>> artifactName = "main.rs";
            attribute :>> sourcePath = "src/main.rs";
            attribute :>> languageName = "Rust";
        }

        part libraryEntrypointSource : SourceFile {
            attribute :>> artifactName = "lib.rs";
            attribute :>> sourcePath = "src/lib.rs";
            attribute :>> languageName = "Rust";
        }

        part protocolServerSource : SourceFile {
            attribute :>> artifactName = "server.rs";
            attribute :>> sourcePath = "src/mcp/server.rs";
            attribute :>> languageName = "Rust";
        }

        part protocolToolsSource : SourceFile {
            attribute :>> artifactName = "tools.rs";
            attribute :>> sourcePath = "src/mcp/tools.rs";
            attribute :>> languageName = "Rust";
        }

        part protocolSchemasSource : SourceFile {
            attribute :>> artifactName = "schemas.rs";
            attribute :>> sourcePath = "src/mcp/schemas.rs";
            attribute :>> languageName = "Rust";
        }

        part projectInspectionSource : SourceFile {
            attribute :>> artifactName = "project.rs";
            attribute :>> sourcePath = "src/core/project.rs";
            attribute :>> languageName = "Rust";
        }

        part commandExecutionSource : SourceFile {
            attribute :>> artifactName = "cargo.rs";
            attribute :>> sourcePath = "src/core/cargo.rs";
            attribute :>> languageName = "Rust";
        }

        part qualityReviewSource : SourceFile {
            attribute :>> artifactName = "review.rs";
            attribute :>> sourcePath = "src/core/review.rs";
            attribute :>> languageName = "Rust";
        }

        part refactoringSource : SourceFile {
            attribute :>> artifactName = "refactor";
            attribute :>> sourcePath = "src/core/refactor";
            attribute :>> languageName = "Rust";
        }

        part protocolRuntimeLibrary : SoftwareLibrary {
            attribute :>> libraryName = "rmcp";
            attribute :>> version = "0.9";
        }

        part asyncRuntimeLibrary : SoftwareLibrary {
            attribute :>> libraryName = "tokio";
            attribute :>> version = "1";
        }

        part architectureConfig : ConfigurationSource {
            attribute :>> sourceName = ".tool42.toml";
            attribute :>> sourceUri = "file://.tool42.toml";
        }
    }

    part def Tool42RuntimeContext {
        part localWorkspace : ExternalSystem {
            attribute :>> systemName = "Rust workspace";
        }

        part localFilesystem : ExternalSystem {
            attribute :>> systemName = "local filesystem";
        }

        part cargoToolchain : ExternalToolDependency {
            attribute :>> dependencyName = "cargo";
        }

        part rustCompilerToolchain : ExternalToolDependency {
            attribute :>> dependencyName = "rustc";
        }

        part clippyToolchain : ExternalToolDependency {
            attribute :>> dependencyName = "clippy";
        }

        part localTrustBoundary : TrustBoundary {
            attribute :>> boundaryName = "local developer machine";
        }

        part workspaceAccessBoundary : ExposureBoundary {
            attribute :>> exposureType = "local-workspace";
            attribute :>> trafficDirection = "inbound";
        }
    }

    part def Tool42ProtocolSurface {
        part stdioEndpoint : CommunicationEndpoint {
            attribute :>> protocol = "stdio-json-rpc";
            attribute :>> path = "stdin-stdout";
            attribute :>> port = 0;
        }

        part protocolSession : CommunicationSession {
            attribute :>> sessionName = "client-server session";
        }

        part toolInvocationBinding : CommunicationBinding {
            attribute :>> bindingName = "json-rpc tool invocation";
        }
    }

    part workspaceDiscoveryContract : SerializedInputContract {
        attribute :>> contractName = "workspace discovery input";
        item :>> payload : JsonPayload {
            attribute :>> mediaType = "application/json";
            attribute :>> schema = "WorkspaceParams";
        }
    }

    part standardResultContract : SerializedOutputContract {
        attribute :>> contractName = "structured tool result";
        item :>> payload : JsonPayload {
            attribute :>> mediaType = "application/json";
            attribute :>> schema = "Tool42 structured content";
        }
    }

    part standardErrorContract : SerializedErrorContract {
        attribute :>> contractName = "structured tool error";
        item :>> payload : JsonPayload {
            attribute :>> mediaType = "application/json";
            attribute :>> schema = "Tool42ErrorEnvelope";
        }
    }

    interface def WorkspaceDiscoveryInterface :> QueryInterface {
        attribute :>> effectKind = "read-only";
    }

    interface def ProjectInspectionInterface :> QueryInterface {
        attribute :>> effectKind = "read-only";
    }

    interface def CommandExecutionInterface :> CommandInterface {
        attribute :>> effectKind = "command";
    }

    interface def FileContextInspectionInterface :> QueryInterface {
        attribute :>> effectKind = "read-only";
    }

    interface def DependencyAndTestInspectionInterface :> QueryInterface {
        attribute :>> effectKind = "read-only";
    }

    interface def ArchitectureAndQualityAnalysisInterface :> AnalysisInterface {
        attribute :>> effectKind = "analysis";
    }

    interface def SemanticChangeReviewInterface :> AnalysisInterface {
        attribute :>> effectKind = "analysis";
    }

    interface def PreviewFirstRefactoringInterface :> MutatingInterface {
        attribute :>> effectKind = "mutating";
    }

    part def Tool42CapabilityRealization :> CapabilityRealization {
        ref protocolOperation : CommunicationOperation;
        ref inputContract : InputContract;
        ref outputContract : OutputContract;
        ref errorContract : ErrorContract;
        ref sourceArtifact : SourceArtifact;
        ref outputPolicy : OutputHandlingPolicy;
        ref safetyPolicy : ExecutionSafetyPolicy;
        ref validation : ValidationStep;
        ref runtimeDependency : RuntimeDependency;
        ref verificationSuite : TestSuite;
        ref trustBoundary : TrustBoundary;
        ref exposureBoundary : ExposureBoundary;
    }

    part def Tool42CapabilitySurface {
        part workspaceDiscoveryOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_workspace";
        }

        part projectInspectionOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_project";
        }

        part checkCommandOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_check";
        }

        part customCommandOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_cargo";
        }

        part fileContextOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_read_search_describe_list";
        }

        part qualityAnalysisOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_analyze_architecture_size_complexity";
        }

        part reviewOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_review_change";
        }

        part refactorOperation : CommunicationOperation {
            attribute :>> operationName = "tool42_refactor_preview_apply";
        }

        part boundedCommandOutput : BoundedOutputPolicy {
            attribute :>> policyName = "cargo output pagination";
        }

        part externalizedLargeOutput : ExternalizedOutputPolicy {
            attribute :>> policyName = "large output file handoff";
        }

        part refactorPreviewPolicy : PreviewPolicy {
            attribute :>> policyName = "preview before apply";
        }

        part explicitApplyPolicy : ApplyPolicy {
            attribute :>> policyName = "apply flag required";
        }

        part postApplyValidation : ValidationStep {
            attribute :>> validationName = "cargo check after refactor apply";
        }

        part failedValidationOutcome : ExecutionFailureOutcome {
            attribute :>> outcomeName = "structured validation failure";
        }
    }

    part def Tool42CapabilityImplementationMap {
        part workspaceDiscovery : Tool42CapabilityRealization {
            attribute :>> realizationName = "workspace discovery realized by mcp adapter and core project module";
            ref workspaceCapability : WorkspaceDiscoveryInterface;
            ref mcpAndProjectImplementation : SoftwareModule;
            ref workspaceProtocolOperation : CommunicationOperation;
            ref workspaceInputContract : InputContract;
            ref workspaceOutputContract : OutputContract;
            ref workspaceErrorContract : ErrorContract;
            ref workspaceSourceArtifact : SourceArtifact;
            ref workspaceBoundary : ExposureBoundary;
        }

        part projectInspection : Tool42CapabilityRealization {
            attribute :>> realizationName = "project inspection realized by mcp adapter and core project module";
            ref projectCapability : ProjectInspectionInterface;
            ref mcpAndProjectImplementation : SoftwareModule;
            ref projectProtocolOperation : CommunicationOperation;
            ref projectInputContract : InputContract;
            ref projectOutputContract : OutputContract;
            ref projectErrorContract : ErrorContract;
            ref projectSourceArtifact : SourceArtifact;
        }

        part commandExecution : Tool42CapabilityRealization {
            attribute :>> realizationName = "cargo execution realized by mcp adapter and core cargo module";
            ref commandCapability : CommandExecutionInterface;
            ref protocolAndCommandImplementation : SoftwareModule;
            ref commandProtocolOperation : CommunicationOperation;
            ref commandInputContract : InputContract;
            ref commandOutputContract : OutputContract;
            ref commandErrorContract : ErrorContract;
            ref commandSourceArtifact : SourceArtifact;
            ref commandOutputPolicy : OutputHandlingPolicy;
            ref commandRuntimeDependency : RuntimeDependency;
            ref commandVerificationSuite : TestSuite;
        }

        part fileContextInspection : Tool42CapabilityRealization {
            attribute :>> realizationName = "file context inspection realized by mcp adapter and core read search describe list modules";
            ref fileContextCapability : FileContextInspectionInterface;
            ref mcpAndFileContextImplementation : SoftwareModule;
            ref fileContextProtocolOperation : CommunicationOperation;
            ref fileContextInputContract : InputContract;
            ref fileContextOutputContract : OutputContract;
            ref fileContextErrorContract : ErrorContract;
            ref fileContextSourceArtifact : SourceArtifact;
            ref fileContextBoundary : ExposureBoundary;
        }

        part dependencyAndTestInspection : Tool42CapabilityRealization {
            attribute :>> realizationName = "dependency and test inspection realized by mcp adapter and core deps tests modules";
            ref dependencyAndTestCapability : DependencyAndTestInspectionInterface;
            ref mcpAndDependencyImplementation : SoftwareModule;
            ref dependencyProtocolOperation : CommunicationOperation;
            ref dependencyInputContract : InputContract;
            ref dependencyOutputContract : OutputContract;
            ref dependencyErrorContract : ErrorContract;
            ref dependencySourceArtifact : SourceArtifact;
            ref dependencyRuntimeDependency : RuntimeDependency;
        }

        part qualityAnalysis : Tool42CapabilityRealization {
            attribute :>> realizationName = "architecture size and complexity analysis realized by mcp adapter and core analysis modules";
            ref qualityAnalysisCapability : ArchitectureAndQualityAnalysisInterface;
            ref mcpAndAnalysisImplementation : SoftwareModule;
            ref qualityProtocolOperation : CommunicationOperation;
            ref qualityInputContract : InputContract;
            ref qualityOutputContract : OutputContract;
            ref qualityErrorContract : ErrorContract;
            ref qualitySourceArtifact : SourceArtifact;
            ref qualityVerificationSuite : TestSuite;
        }

        part semanticReview : Tool42CapabilityRealization {
            attribute :>> realizationName = "semantic change review realized by mcp adapter and core review module";
            ref reviewCapability : SemanticChangeReviewInterface;
            ref mcpAndReviewImplementation : SoftwareModule;
            ref reviewProtocolOperation : CommunicationOperation;
            ref reviewInputContract : InputContract;
            ref reviewOutputContract : OutputContract;
            ref reviewErrorContract : ErrorContract;
            ref reviewSourceArtifact : SourceArtifact;
            ref reviewVerificationSuite : TestSuite;
        }

        part previewFirstRefactoring : Tool42CapabilityRealization {
            attribute :>> realizationName = "preview-first refactoring realized by mcp adapter and core refactor module";
            ref refactoringCapability : PreviewFirstRefactoringInterface;
            ref mcpAndRefactorImplementation : SoftwareModule;
            ref refactorProtocolOperation : CommunicationOperation;
            ref refactorInputContract : InputContract;
            ref refactorOutputContract : OutputContract;
            ref refactorErrorContract : ErrorContract;
            ref refactorSourceArtifact : SourceArtifact;
            ref refactorSafetyPolicy : ExecutionSafetyPolicy;
            ref refactorValidation : ValidationStep;
            ref refactorVerificationSuite : TestSuite;
            ref refactorBoundary : ExposureBoundary;
        }
    }

    part def Tool42DeliveryModel {
        part serverBinaryArtifact : BuildArtifact {
            attribute :>> artifactName = "tool42";
            attribute :>> artifactUri = "crates.io/tool42";
            attribute :>> version = "0.2.0";
        }

        part vscodeExtensionArtifact : BuildArtifact {
            attribute :>> artifactName = "tool42-vscode";
            attribute :>> artifactUri = "vscode-extension/package.json";
            attribute :>> version = "0.2.0";
        }

        part serverExtensionCompatibility : CompatibilityContract {
            attribute :>> contractName = "server-extension version compatibility";
            attribute :>> versionPolicy = "same major and minor version";
        }

        part unitTestSuite : TestSuite {
            attribute :>> suiteName = "cargo test";
        }

        part mcpHarnessSuite : TestSuite {
            attribute :>> suiteName = "Mandrel MCP harness";
        }
    }

    part def Tool42OperationalModel {
        part versionHealthSignal : HealthSignal {
            attribute :>> signalName = "server version available";
            attribute :>> healthState = "ready-or-mismatch";
        }

        part diagnoseHealthSignal : HealthSignal {
            attribute :>> signalName = "workspace and toolchain diagnose";
            attribute :>> healthState = "healthy-or-actionable";
        }

        part statusLogSource : LogSource {
            attribute :>> sourceName = "VS Code output channel";
        }

        part statusMetricSource : MetricSource {
            attribute :>> sourceName = "VS Code status bar";
        }
    }

    part def Tool42BehaviorModel {
        part requestHandling : InteractionScenario;

        part agentLifeline : Lifeline;
        part clientLifeline : Lifeline;
        part serverLifeline : Lifeline;
        part dispatcherLifeline : Lifeline;
        part implementationLifeline : Lifeline;
        part externalRuntimeLifeline : Lifeline;

        part receiveRequest : SynchronousCall {
            attribute :>> label = "receive structured tool request";
        }

        part validateRequest : SynchronousCall {
            attribute :>> label = "validate request contract";
        }

        part dispatchOperation : SynchronousCall {
            attribute :>> label = "dispatch to capability realization";
        }

        part executeCapability : SynchronousCall {
            attribute :>> label = "execute implementation module";
        }

        part invokeExternalRuntime : SynchronousCall {
            attribute :>> label = "invoke external runtime when required";
        }

        part formatResponse : SynchronousCall {
            attribute :>> label = "format bounded structured response";
        }

        part returnResult : ReturnMessage {
            attribute :>> label = "return result or structured error";
        }
    }

    part def Tool42System {
        part codebase : Tool42Codebase;
        part runtimeContext : Tool42RuntimeContext;
        part protocolSurface : Tool42ProtocolSurface;
        part capabilitySurface : Tool42CapabilitySurface;
        part capabilityImplementationMap : Tool42CapabilityImplementationMap;
        part delivery : Tool42DeliveryModel;
        part operations : Tool42OperationalModel;
        part behavior : Tool42BehaviorModel;

        part aiAssistant : ExternalSystem {
            attribute :>> systemName = "AI coding assistant";
        }

        part mcpClient : ExternalSystem {
            attribute :>> systemName = "MCP-compatible client";
        }

        part tool42Server : Service {
            attribute :>> serviceName = "tool42 MCP server";
        }

        part vscodeWrapper : SoftwareComponent;
    }

    part tool42 : Tool42System;

    view systemStructure : GeneralView {
        expose Tool42SystemModel::tool42;
    }

    view implementationStructure : GeneralView {
        expose Tool42SystemModel::Tool42Codebase;
    }

    view capabilitySurface : GeneralView {
        expose Tool42SystemModel::Tool42CapabilitySurface;
    }

    view capabilityTraceability : GeneralView {
        expose Tool42SystemModel::Tool42CapabilityImplementationMap;
    }

    view runtimeAndProtocolContext : GeneralView {
        expose Tool42SystemModel::Tool42RuntimeContext;
        expose Tool42SystemModel::Tool42ProtocolSurface;
    }

    view deliveryAndOperations : GeneralView {
        expose Tool42SystemModel::Tool42DeliveryModel;
        expose Tool42SystemModel::Tool42OperationalModel;
    }

    view requestHandlingBehavior : GeneralView {
        expose Tool42SystemModel::Tool42BehaviorModel;
    }

}
