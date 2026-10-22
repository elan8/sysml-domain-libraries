package LayeredApplication {
    doc /* Architectural composition for an application that could be implemented
         * in C#. Components identify responsibilities, not individual classes or
         * projects. Ports show runtime interactions, not source dependencies. */
    private import Elan8::Software::*;
    private import StandardViewDefinitions::*;

    item def MotionRequest;
    item def MotionResult;
    item def SettingsRequest;
    item def SettingsResult;
    item def SettingsRecord;

    action def LoadSettings :> QueryOperation {
        in request : SettingsRequest;
        out result : SettingsResult;
    }
    action def SaveSettings :> CommandOperation {
        in request : SettingsRequest;
        out result : SettingsResult;
    }
    part def SettingsServiceContract :> SoftwareServiceContract {
        action load : LoadSettings;
        action save : SaveSettings;
    }
    part def SettingsDataStore :> SoftwareDataStore {
        attribute :>> persistence = DataStorePersistence::persistent;
        item entries : SettingsRecord[0..*];
    }

    port def MotionApi :> RequestReplyPort {
        in item :>> request : MotionRequest;
        out item :>> reply : MotionResult;
    }
    port def SettingsApi :> RequestReplyPort {
        in item :>> request : SettingsRequest;
        out item :>> reply : SettingsResult;
    }

    part def MissionService :> SoftwareModule {
        port motion : ~MotionApi;
        port settings : ~SettingsApi;
    }
    part def SettingsRepository :> SoftwareModule, SettingsServiceContract {
        port settings : SettingsApi;
        ref part store : SettingsDataStore;
    }
    part def MotorAdapter :> SoftwareModule {
        port motion : MotionApi;
    }
    part def DiagnosticService :> SoftwareModule;

    part def ServicesLayer :> SoftwareLayer {
        attribute :>> color default = "#DCEBFA";
        part mission : MissionService;
    }
    part def InfrastructureLayer :> SoftwareLayer {
        attribute :>> color default = "#E2F0D9";
        part settings : SettingsRepository;
        part settingsData : SettingsDataStore;
        bind settings.store = settingsData;
    }
    part def HardwareAbstractionLayer :> SoftwareLayer {
        attribute :>> color default = "#FFF2CC";
        part motors : MotorAdapter;
    }

    part def RobotApplication :> SoftwareApplication {
        part services : ServicesLayer;
        part infrastructure : InfrastructureLayer;
        part hal : HardwareAbstractionLayer;
        connect services.mission.settings to infrastructure.settings.settings;
        connect services.mission.motion to hal.motors.motion;
    }
    part def DiagnosticsApplication :> SoftwareApplication {
        doc /* Applications can also compose components directly, without layers. */
        part diagnostics : DiagnosticService;
    }

    part system {
        part robotApplication : RobotApplication;
        part diagnosticsApplication : DiagnosticsApplication;
    }

    view applications : GeneralView {
        doc /* Inventory of the application's occurrences within this system.
             * Tools can discover these by SoftwareApplication ancestry; this
             * example makes the two selections explicit. */
        expose system.robotApplication;
        expose system.diagnosticsApplication;
    }
    view layers : GeneralView {
        doc /* Follow application composition to show layers and their components.
             * A renderer can use SoftwareLayer.color for consistent layer colors.
             * This view does not prescribe a stacked layout or enforce layering. */
        expose system.robotApplication;
    }
}
