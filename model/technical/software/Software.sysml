package Software {
    doc /*
     * Generic software concepts that tools act on: components, operations
     * (queries and commands), interaction ports, tasks, execution platforms
     * and queues. Behaviour is native SysML (`state`, `action`, `send`,
     * `accept`); deployment is native `allocate`. Technology choices are
     * metadata in Elan8::Software::Bindings. See docs/library-design.md.
     */
    private import ISQ::*;
    private import ScalarValues::*;
    private import Metaobjects::SemanticMetadata;

    // ------------------------------------------------------------------
    // Components
    // ------------------------------------------------------------------

    abstract part def SoftwareComponent {
        doc /*
         * A unit of software with its own behaviour and interfaces. Its
         * operations are action usages it owns, its interfaces are ports, and
         * its implemented behaviour is the state machines it owns or exhibits.
         */
    }
    abstract part softwareComponents : SoftwareComponent[0..*] nonunique :> Parts::parts;

    metadata def <software> SoftwareMetadata :> SemanticMetadata {
        doc /* Keyword `#software`: the declared part is a SoftwareComponent. */
        :>> baseType = softwareComponents meta SysML::Usage;
    }

    metadata def <external> External {
        doc /*
         * Keyword `#external`: a component realised outside the project
         * (third-party, off-the-shelf or legacy). Generators do not generate
         * it, and verification treats its contract as an assumption.
         */
    }

    // ------------------------------------------------------------------
    // Operations
    // ------------------------------------------------------------------

    abstract action def SoftwareOperation {
        doc /*
         * A callable unit of software behaviour: a function, a method or a
         * remote operation. Its `in` and `out` parameters are its signature;
         * errors are `out` items; preconditions and postconditions are
         * constraints. A function is an operation definition; a method is an
         * operation usage owned by a SoftwareComponent.
         */
    }
    abstract action softwareOperations : SoftwareOperation[0..*] nonunique :> Actions::actions;

    abstract action def QueryOperation :> SoftwareOperation {
        doc /*
         * An operation that returns information and has no effect outside its
         * own execution: it assigns no feature of its owner or of anything
         * else, does not send, and performs no command, directly or through
         * another operation. Its `out` parameters are its result. A query is
         * idempotent by definition. An operation is not both a query and a
         * command.
         */
    }
    abstract action queryOperations : QueryOperation[0..*] nonunique :> softwareOperations;

    abstract action def CommandOperation :> SoftwareOperation {
        doc /*
         * An operation that may change state or emit messages and events.
         * Under strict command-query separation, a project option, it returns
         * only completion or an error. An operation is not both a query and a
         * command.
         */
    }
    abstract action commandOperations : CommandOperation[0..*] nonunique :> softwareOperations;

    metadata def <operation> OperationMetadata :> SemanticMetadata {
        doc /* Keyword `#operation`: an operation not yet classified as query or command. Tools treat it as a command. */
        :>> baseType = softwareOperations meta SysML::Usage;
    }
    metadata def <query> QueryMetadata :> SemanticMetadata {
        doc /* Keyword `#query`: the declared action is a QueryOperation. */
        :>> baseType = queryOperations meta SysML::Usage;
    }
    metadata def <command> CommandMetadata :> SemanticMetadata {
        doc /* Keyword `#command`: the declared action is a CommandOperation. */
        :>> baseType = commandOperations meta SysML::Usage;
    }

    metadata def <idempotent> Idempotent {
        doc /*
         * Keyword `#idempotent`: a command that can be performed more than once
         * with the same effect as once, so it can be retried or delivered at
         * least once safely.
         */
    }

    // ------------------------------------------------------------------
    // Interaction ports
    // ------------------------------------------------------------------

    abstract port def InteractionPort {
        doc /*
         * How two software components interact. Each kind is defined from the
         * providing side; the other side uses the conjugated port. A port
         * definition for one interface specialises a kind and redefines its
         * items with the payload types, for example
         * `port def PoseService :> RequestReplyPort { in item :>> request : PoseRequest; out item :>> reply : Pose; }`.
         */
    }

    port def RequestReplyPort :> InteractionPort {
        doc /* A synchronous call: the provider receives a request and returns a reply. */
        in item request;
        out item reply;
        attribute timeout : DurationValue[0..1];
    }
    abstract port requestReplyPorts : RequestReplyPort[0..*] nonunique :> Ports::ports;

    port def MessagePort :> InteractionPort {
        doc /* A one-way message, command or event: sent without waiting for a reply. */
        out item payload;
        attribute rate : FrequencyValue[0..1];
        attribute maximumSize : StorageCapacityValue[0..1];
    }
    abstract port messagePorts : MessagePort[0..*] nonunique :> Ports::ports;

    port def StreamPort :> InteractionPort {
        doc /* A continuous flow of samples at a rate. */
        out item sample;
        attribute rate : FrequencyValue[0..1];
    }
    abstract port streamPorts : StreamPort[0..*] nonunique :> Ports::ports;

    metadata def <call> CallMetadata :> SemanticMetadata {
        doc /* Keyword `#call`: the declared port is a RequestReplyPort. */
        :>> baseType = requestReplyPorts meta SysML::Usage;
    }
    metadata def <oneway> OnewayMetadata :> SemanticMetadata {
        doc /* Keyword `#oneway`: the declared port is a MessagePort. */
        :>> baseType = messagePorts meta SysML::Usage;
    }
    metadata def <stream> StreamMetadata :> SemanticMetadata {
        doc /* Keyword `#stream`: the declared port is a StreamPort. */
        :>> baseType = streamPorts meta SysML::Usage;
    }

    // ------------------------------------------------------------------
    // Tasks, platforms and queues
    // ------------------------------------------------------------------

    enum def TaskCriticality {
        nonCritical;
        missionCritical;
        safetyCritical;
    }

    abstract part def Task :> SoftwareComponent {
        doc /*
         * A schedulable unit of execution. Deployment is
         * `allocate task to platform;`. Timing analysis reads the deadline,
         * the worst-case execution time and the activation of each task
         * allocated to a platform.
         */
        attribute deadline : DurationValue;
        attribute worstCaseExecutionTime : DurationValue[0..1];
        attribute priority : Integer[0..1] {
            doc /* Higher values run first under a fixed-priority policy. */
        }
        attribute criticality : TaskCriticality[0..1];
    }
    abstract part tasks : Task[0..*] nonunique :> softwareComponents;

    abstract part def PeriodicTask :> Task {
        doc /* A task released at a fixed period. */
        attribute period : DurationValue;
    }

    abstract part def EventDrivenTask :> Task {
        doc /*
         * A task released by an event. Its minimum inter-arrival time bounds how
         * often it can be released; timing analysis needs it.
         */
        attribute minimumInterArrivalTime : DurationValue[0..1];
    }

    metadata def <task> TaskMetadata :> SemanticMetadata {
        doc /* Keyword `#task`: the declared part is a Task. */
        :>> baseType = tasks meta SysML::Usage;
    }

    enum def SchedulingPolicy {
        fixedPriorityPreemptive;
        fixedPriorityCooperative;
        earliestDeadlineFirst;
        roundRobin;
    }

    part def ExecutionPlatform {
        doc /*
         * What executes software: an operating system or runtime on a
         * processor, a virtual machine or a container node. A platform is
         * allocated to the hardware that hosts it (for example an
         * Elan8::Electronics::Compute::Microcontroller), and tasks are
         * allocated to the platform.
         */
        attribute schedulingPolicy : SchedulingPolicy[0..1];
        attribute tickPeriod : DurationValue[0..1];
        attribute memory : StorageCapacityValue[0..1];
    }
    abstract part executionPlatforms : ExecutionPlatform[0..*] nonunique :> Parts::parts;

    metadata def <platform> PlatformMetadata :> SemanticMetadata {
        doc /* Keyword `#platform`: the declared part is an ExecutionPlatform. */
        :>> baseType = executionPlatforms meta SysML::Usage;
    }

    enum def QueueDiscipline {
        fifoDropNewest;
        fifoDropOldest;
        overwriteLatest;
    }

    part def SoftwareQueue {
        doc /*
         * A bounded buffer between software components. The discipline says
         * what happens when it is full; verification checks for overflow
         * against the capacity.
         */
        attribute discipline : QueueDiscipline[0..1];
        attribute capacity : Natural[0..1];
    }

    public import Bindings;
}
