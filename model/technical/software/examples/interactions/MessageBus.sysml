package MessageBusExample {
    private import Elan8::Software::*;
    private import StandardViewDefinitions::*;

    item def CleaningCompleted;
    port def CompletionEvents :> MessagePort {
        out item :>> payload : CleaningCompleted;
    }
    part def CleaningModule :> SoftwareModule { port completed : CompletionEvents; }
    part def NotificationModule :> SoftwareModule { port completed : ~CompletionEvents; }
    part def HistoryModule :> SoftwareModule { port completed : ~CompletionEvents; }
    part def InProcessBus :> SoftwareModule {
        port published : ~CompletionEvents;
        port notifications : CompletionEvents;
        port history : CompletionEvents;
        doc /* An in-process event dispatcher. This example specifies topology only;
             * it makes no durability, ordering, retry or threading guarantee.
             * It has no datastore or queue because neither is assumed. */
    }
    part def Application :> SoftwareApplication {
        part cleaning : CleaningModule;
        part bus : InProcessBus;
        part notifications : NotificationModule;
        part history : HistoryModule;
        connect cleaning.completed to bus.published;
        connect bus.notifications to notifications.completed;
        connect bus.history to history.completed;
    }
    part application : Application;
    view dispatch : GeneralView { expose application; }
}
