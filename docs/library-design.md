# Library design

Status: proposal. Nothing in `model/` changes until this document is agreed. The design and its
snippets follow the OMG SysML v2.0 specification (section numbers refer to it), not the behaviour of
any one tool.

This document sets out what the Elan8 libraries are for, what belongs in them, and how a tool
knows what to do with a model built from them. It reviews the current packages against that, and
proposes a target structure and a migration path.

## 1. Purpose

The libraries exist to make two things easier:

- **For an engineer:** expressing a system precisely with less work. A library definition carries
  knowledge the engineer would otherwise have to work out and write: typed ports, quantities with
  units, ratings, constraints.
- **For a tool:** doing something useful with the model without guessing. A code generator,
  verifier, simulator or budget calculation recognises a library concept by its type and knows
  what it means.

A definition that does neither (a name with no features, a placeholder type, a copy of a SysML
concept) costs the engineer time to learn and gives tools nothing to act on.

## 2. The value test

A library element belongs in the library when it passes at least one of the first two tests and
does not fail the last two.

1. **It carries knowledge.** Typed features, ports, quantities with units and constraints that a
   user would otherwise write. `Resistor` with typed terminal ports, `resistance`, `ratedPower`
   and `maximumWorkingVoltage` passes; `part def KafkaConsumerGroup { attribute groupName : Name; }`
   does not.
2. **It means something a tool can act on.** A tool recognises it by type conformance
   (`:> Resistor`, `#operation`) and can check, compute, simulate or generate from it.
3. **It is stable, or kept to one side.** Generic concepts stay generic. Technology specifics
   (a protocol, a broker, a container platform) live in metadata and bindings that can change
   without disturbing the core.
4. **It does not duplicate SysML.** State machines, actions, messages, interactions, allocation,
   requirements and verification are native SysML v2 and are used, not re-modelled.

## 3. Principles

### 3.1 Native SysML first

The library specialises the SysML standard library and adds meaning; it never redefines what SysML
already has.

| Concept | Use | Not |
|---|---|---|
| State machine | `state def`, `exhibit state` | a `StateMachine` part def |
| Operation, function, method | `action def` (see 4.1) | a part def or an interface def |
| Event, message, signal | `item def` payloads with `send` / `accept`, `message`, `flow` | `Lifeline`, `Activation` or `Message` part defs |
| Interaction, sequence | occurrences, messages and successions | `CombinedFragment`, `AltFragment` part defs |
| Deployment | `allocate` | `ref` features named `deployedOn` |
| Requirement, verification | `requirement def`, `verification def`, `VerificationMethod` | custom requirement classes |

### 3.2 Three layers tell a tool what to do

A tool decides what an element *is*, what it is *for*, and *how* to process it, from three kinds of
fact, never from names, folders or documentation text:

1. **Role, by type.** What the element is: `:> SoftwareComponent`, `:> Task`, `:> Resistor`. Library
   concepts are recognised by type conformance, so a project's own specialisations are recognised
   too.
2. **Intent, by relationship.** What the element is used for: who owns or `exhibit`s a state
   machine, which component a behaviour is `allocate`d to, which requirement a constraint
   `satisfy`s, which part a verification case has as its subject.
3. **Options, by metadata.** How a tool should process it: target language, protocol, generation
   style, broker settings. Metadata never changes what an element is; it parameterises a tool.

### 3.3 Typed values only

Every numeric value is a quantity with a unit (`DurationValue`, `PowerValue`, `FrequencyValue`) or a
typed scalar. No untyped placeholder `attribute def`s ("name meant to be specialized"), and no
`attribute name : Name` on definitions: an element's SysML name is its name.

### 3.4 Technology as metadata, generic concepts as definitions

A `part def` or `port def` is for something an engineer composes and a tool computes over. A
technology choice (gRPC, Kafka, HTTP, CAN, Kubernetes) is recorded as metadata that carries exactly
the parameters a generator or deployment tool needs, on a generic element. The technology's own
specification (a `.proto`, an OpenAPI or AsyncAPI document, a CAN DBC) is referenced, not
re-modelled.

### 3.5 Keywords

SysML v2 lets a library define keywords (7.27.4): `#name` before a declaration applies the metadata
definition `name`. When that definition specialises `SemanticMetadata` with a `baseType`, the
keyword also specialises the base implicitly, so `#query action def CurrentPose` makes
`CurrentPose` a `QueryOperation` (7.27.3), with everything that implies: its inherited features
can be redefined and tools see the specialisation like any other.

A keyword is shorthand for `:>` plus a recognisable role; it adds no meaning of its own. It earns its
place only when all of these hold:

1. it marks a **role tools act on** (generation, verification, analysis);
2. engineers **declare new definitions of that role often**, so the shorthand pays off;
3. it **reads as a natural modelling word** in front of the SysML keyword;
4. its name is short, lower case, unambiguous across Elan8 libraries, and **not a SysML reserved
   word** (`event`, `message`, `interface`, `flow` and `language` are reserved).

That gives a deliberately small set.

**Role keywords** (semantic metadata, implicit specialisation):

| Keyword | Specialises | Example |
|---|---|---|
| `#software` | `SoftwareComponent` | `#software part def Navigator { … }` |
| `#task` | `Task` | `#task part def MotorControlLoop { … }` |
| `#platform` | `ExecutionPlatform` | `#platform part def MainMcu { … }` |
| `#query` | `QueryOperation` | `#query action def CurrentPose { out pose : Pose; }` |
| `#command` | `CommandOperation` | `#command action def SetSpeed { in speed : SpeedValue; }` |
| `#operation` | `SoftwareOperation` | an operation not yet classified as query or command |
| `#call` | `RequestReplyPort` | `#call port def PoseService { in item :>> request : PoseRequest; out item :>> reply : Pose; }` |
| `#oneway` | `MessagePort` | `#oneway port def SpeedCommands { out item :>> payload : SpeedCommand; }` |
| `#stream` | `StreamPort` | `#stream port def ImuSamples { out item :>> sample : ImuSample; }` |

**Marker keywords** (plain metadata without attributes, which also works as `#name`):

| Keyword | Meaning |
|---|---|
| `#idempotent` | a command that can be repeated safely (4.1) |
| `#external` | a component realised outside the project (third-party, off-the-shelf, legacy): generators do not generate it, and verification treats its contract as an assumption |

**No keywords** for:

- electronics and mechanical kinds: engineers mostly type usages (`part r : Resistor`) rather than
  declare new definitions, and `:>` reads well where they do;
- technology bindings with parameters (`Rpc`, `Topic`, `HttpRoute`): they need a body,
  `@Rpc { … }`, so a keyword adds nothing;
- views and analysis cases: they are typed (`: CodeGenerationView`), which is already the native
  form;
- contracts: preconditions, postconditions and invariants are native constraints.

Conventions:

- **Always pair a keyword with the SysML keyword** (`#query action def`, not `#query def`). SysML
  allows the bare form (7.27.4), but it hides the metaclass from the reader.
- **A clash is resolved by qualification:** `#Elan8::Software::query` always works.
- **Every keyword has a `:>` equivalent,** so models written either way mean the same and tools
  check only the type.

## 4. Answers to the design questions

### 4.1 Software operations: functions and methods

A software operation (a function, a method, a remote procedure) is an `action def`. Its parameters
are its signature; its body, when modelled, is native action behaviour:

```sysml
abstract action def SoftwareOperation {
    doc /* A callable unit of software behaviour: a function, a method or a remote operation.
         * Its `in` and `out` parameters are its signature. */
}
abstract action softwareOperations : SoftwareOperation[0..*] nonunique;

metadata def <operation> OperationMetadata :> Metaobjects::SemanticMetadata {
    :>> baseType = softwareOperations meta SysML::Usage;
}
```

- **A function** is an operation definition: `#operation action def ComputeOdometry { in left : …; in right : …; out pose : Pose; }`.
- **A method** is an operation usage owned by a component: `part def Navigator :> SoftwareComponent { #operation action plan : PlanPath; }`.
- **An operation offered to other components** is exposed through a request–reply port (5.2) whose
  request and reply items match its parameters.
- **Contracts** are native: preconditions and postconditions as `constraint`s on the operation,
  errors as `out` items. A verifier reads them; a generator can emit assertions.

What this gives a generator: one function or method signature per operation, typed from its
parameters, and the right place for it (free function or member of the owning component).

#### Queries and commands

Operations come in two kinds, following command–query separation. The kind is a type, with a
keyword, so tools recognise it the same way as everything else:

```sysml
abstract action def QueryOperation :> SoftwareOperation;    // keyword #query
abstract action def CommandOperation :> SoftwareOperation;  // keyword #command
metadata def Idempotent;                                    // a command that can be safely repeated

part def Navigator :> SoftwareComponent {
    attribute targetSpeed : SpeedValue;
    #query action def CurrentPose { out pose : Pose; }
    #command action def SetSpeed { in speed : SpeedValue; @Idempotent; }
}
```

The two kinds have a precise meaning, which is what makes them checkable:

- **A query** returns information and has no effect outside its own execution. It does not assign
  a feature of its owner or of anything else, does not `send`, and does not perform a command,
  directly or through another operation. Its `out` parameters are its result. Queries are
  idempotent by definition.
- **A command** may change state or emit messages and events. Under strict command–query separation
  it returns no domain data, only completion or an error; because many designs return the
  identifier of something they create, strict separation is an option a project switches on, not a
  rule of the library.
- **Idempotency** is separate from the kind. `setSpeed(5)` is an idempotent command; `increment()` is
  not. It matters wherever a command can be delivered or retried more than once.
- **An unclassified** `SoftwareOperation` is allowed while a design is immature. Tools treat it as a
  command, the conservative assumption.

The two kinds are mutually exclusive. SysML's textual notation cannot state that for definitions:
`DefinitionDeclaration` is `Identification SubclassificationPart?` (8.2.2), and disjoining
(`disjoint from`) exists only in KerML (KerML 7.3.2.5). So "an operation is not both a query and a
command" is a rule of this library, stated in the definitions' documentation and checked by tools.

What this enables:

| Use | Query | Command |
|---|---|---|
| Model checks | the body contains no `assign` to non-local features, no `send` and no command call (transitively); a transition guard, `if` condition, constraint or requirement calls only queries | strict separation (when switched on): no `out` parameters but status |
| Interface checks | an HTTP `GET` or `HEAD` binding must bind a query; a query on a message port is suspect | a non-idempotent command on an at-least-once channel (`Topic`, retrying RPC) is flagged unless the receiver deduplicates |
| Formal verification | a pure function: usable in properties and contracts; leaves state unchanged, so its frame condition is implied; concurrent queries commute, which shrinks the state space (partial-order reduction) | the only state transitions: the transition relation is built from commands; their pre- and postconditions are proof obligations; invariants need checking only after commands |
| Code generation | `const` method, `&self`, pure function; results may be cached | mutating method (`&mut self`); retry and deduplication code only where the command is not idempotent |

These checks need the operation's body to be modelled; for an operation without a body, the kind
is a contract that generated code and code-level checks enforce (for example a `const` method).

### 4.2 Which state machines become code?

A state machine in a model is either a **specification** (what some part must do) or an
**implementation** (what a software component does). The difference is a relationship, not a
property of the state machine:

| Situation | Meaning | A code generator |
|---|---|---|
| `exhibit state` (or an owned `state`) of a `SoftwareComponent` | the component's implemented behaviour | generates it |
| a state machine of a logical or system part, `allocate`d to a `SoftwareComponent` | a specification the component realises | generates it for that component, or checks the implementation against it |
| a state machine of a non-software part, not allocated | a specification only | ignores it |

On top of that, generation is never implicit for the whole model. **The scope of a generation run
is a SysML view**: a view selects elements with `expose` and `filter` and produces an artifact,
which is exactly what SysML views are for, and what Doc42 already uses for documents.

```sysml
view firmwareCode : CodeGenerationView {
    expose Firmware::*;
    @CodeGeneration { targetLanguage = Language::c; style = StateMachineStyle::table; }
}
```

The library provides `CodeGenerationView` and the `CodeGeneration` options metadata; a generator
plugin is the view's rendering. One model can have several generation views (firmware in C, a
simulator in Python), each with its own scope and options.

### 4.3 The same pattern for other constructs and tools

| Tool | Role (type) | Intent and scope (relationship, view, case) | Options (metadata) |
|---|---|---|---|
| Code generation | `SoftwareComponent`, `QueryOperation` / `CommandOperation`, interaction ports, payload `item def`s, `state def`s | ownership, `exhibit`, `allocate`; a `CodeGenerationView` | `CodeGeneration`, technology bindings (`Rpc`, `Topic`, `HttpRoute`, …), `SourceCode` |
| Formal verification | `state def`s, queries and commands, interaction ports, constraints | a `verification def` whose subject is the component and whose objective names the requirements; `VerificationMethod` = analysis | `FormalVerification { technique; bound; }` |
| Timing analysis | `Task`, `ExecutionPlatform` | `allocate` task to platform; an `analysis def` over a platform | scheduling policy on the platform |
| Simulation | physical ports, parameters with units, `ModelicaModel` / `FmuModel` | an `analysis def` specialising `SimulationScenario` (subject, inputs, outputs, horizon) | solver settings on the case |
| Budgets and BOM | quantities with units, `BomItem` | roll-up `calc`s and the decomposition | currency, sourcing |

The rule is the same everywhere: the type says what it is, a relationship, view or case says that a
tool should process it, and metadata says how.

## 5. Target structure

### 5.1 Packages

| Package | Contents | Verdict |
|---|---|---|
| `Elan8::Core` | `PhysicalComponent` (mass) | keep, drop `Name` and `name` |
| `Elan8::Units` | engineering and monetary units | keep |
| `Elan8::Procurement` | `BomItem` and sourcing metadata | keep |
| `Elan8::PhysicalModeling` | `ModelicaModel`, `FmuModel`, `ExternalVariable`, `SimulationScenario` | keep: the reference for how bindings should look |
| `Elan8::Electronics` | components with typed terminals and ratings, power, sensing, actuation, buses, including the component catalogue (`Resistor`, `Mosfet`, `BldcMotor`, `Microcontroller`, …) | keep, catalogue included: these are generic kinds of component, with no vendor or part-number content. Remove placeholder types (`SignalKind`, `VoltageClass`, …) and `name` attributes; make bus and interface kinds typed ports; move application roles out (5.4) |
| `Elan8::Mechanical` | rotational and translational ports, drivetrain | keep; extend in the same style (across and through variables) |
| `Elan8::Software` | 5.2 | rebuild around operations, interaction ports, tasks and platforms |
| `Elan8::Software::Interactions` | sequence-diagram notation as part defs | delete: native SysML interactions |
| `Elan8::Communication` and technology packages (gRPC, Kafka, HTTP, OpenAPI, SQL, NoSQL, Kubernetes, cloud) | empty specialisations and untyped attributes | convert to technology metadata (5.3); delete the rest |
| `Elan8::Generation` (new) | `CodeGenerationView`, `CodeGeneration`, `FormalVerification`, `SourceCode`, `InterfaceSpec` | add |

### 5.2 Software

```sysml
package Software {
    abstract part def SoftwareComponent :> Parts::Part {
        port interactions : InteractionPort[0..*];
        // behaviour: native `state` and `action` usages, operations (4.1)
    }

    abstract action def SoftwareOperation;                 // 4.1, keyword #operation
    abstract action def QueryOperation :> SoftwareOperation;    // keyword #query
    abstract action def CommandOperation :> SoftwareOperation;  // keyword #command

    abstract port def InteractionPort;
    port def RequestReplyPort :> InteractionPort {         // synchronous call
        in item request; out item reply;
        attribute timeout : DurationValue[0..1];
    }
    port def MessagePort :> InteractionPort {              // one-way message or event
        out item payload;
        attribute rate : FrequencyValue[0..1];
        attribute maximumSize : StorageCapacityValue[0..1];
    }
    port def StreamPort :> InteractionPort {               // continuous data
        out item sample;
        attribute rate : FrequencyValue;
    }

    part def Task :> SoftwareComponent {                   // keyword #task
        attribute period : DurationValue[0..1];            // absent for a sporadic task
        attribute deadline : DurationValue;
        attribute worstCaseExecutionTime : DurationValue;
        attribute priority : Integer;
    }

    part def ExecutionPlatform {                           // processor, virtual machine, container node
        attribute processingCapacity : FrequencyValue[0..1];
        attribute memory : StorageCapacityValue[0..1];
    }
    // deployment: `allocate task to platform;`
}
```

Ports are conjugated on the other side (`~RequestReplyPort`) as usual, so a tool can check that
every request has a matching reply and that payload types agree. Messages and events are `item def`s
the engineer defines; the ports say how they travel.

### 5.3 Technology bindings

Each technology becomes metadata on a generic element, carrying only what a tool needs:

```sysml
metadata def Rpc        { :> annotatedElement : SysML::ActionDefinition;
                          attribute protocol : RpcProtocol;      // grpc, jsonRpc, …
                          attribute streaming : StreamingKind; } // unary, server, client, bidirectional
metadata def Topic      { attribute broker : BrokerKind; attribute topicName : String; attribute key : String[0..1]; }
metadata def HttpRoute  { attribute method : HttpMethod; attribute path : String; }
metadata def CanFrame   { attribute frameId : Natural; attribute dbc : String[0..1]; }
metadata def Container  { attribute image : String; attribute replicas : Natural[0..1]; }
metadata def SourceCode { attribute path : String; attribute codeLanguage : Language; attribute entryPoint : String[0..1]; }
metadata def InterfaceSpec { attribute uri : String; attribute format : SpecFormat; } // proto, openApi, asyncApi, dbc
```

Metadata values are literals (see `conventions.md`); quantities stay on the parts and ports.

A binding is written inside the body of the element it applies to, or as a keyword prefix:

```sysml
action def GetQuote { @Rpc { protocol = RpcProtocol::grpc; streaming = StreamingKind::unary; } }
```

A standalone `@Rpc { … }` written before a declaration annotates the enclosing package, not the
declaration that follows it.

Names must avoid SysML's reserved words, which include `message`, `language`, `loop`, `frame` and
`derived`; hence `payload`, `targetLanguage` and `codeLanguage` above.

### 5.4 Generic kinds, not application roles

A library definition names a **kind** of thing defined by its technology or physics (a switch, an
infrared receiver, a brushless motor), never a **role** it plays in one application (a bumper, a
docking beacon). Roles belong in the model that has them, as specialisations of the library kind.
Vendor- and part-number-specific content (a particular MCU, a manufacturer's capacitor series) does
not belong in the library either; it is project data, or an optional catalogue built on the
library.

Four electronics definitions are application roles from the robot vacuum and move to that model:

| Now in `Elan8::Electronics::Sensing` | Becomes |
|---|---|
| `BumperSwitch`, `LiftSwitch` | the robot's own `:> SwitchSensor` definitions; the library keeps `SwitchSensor` |
| `HomingBeaconTransmitter`, `HomingBeaconReceiver` and `HomingBeaconPort` | generic `InfraredTransmitter`, `InfraredReceiver` and an infrared port in the library; the robot's beacon specialises them |

## 6. What a tool needs from the libraries

- **Stable types to recognise.** Every concept a tool acts on is a library definition or keyword;
  tools test conformance, never names.
- **Complete signatures.** Operations and interaction ports have typed parameters and payloads.
- **Typed numbers.** Timing, rates, sizes, ratings and physical variables carry units.
- **Explicit scope.** Generation, verification and simulation runs are views, verification cases and
  analysis cases, so a run is reproducible and reviewable in the model itself.
- **References out, not copies.** Technology specifications and source code are referenced by
  metadata, so the model and the artifact can be checked against each other in both directions.

## 7. Migration

1. **Agree this document.**
2. **Vertical slice for software.** `SoftwareComponent`, `SoftwareOperation`, the three interaction
   ports, `Task`, `ExecutionPlatform`, `CodeGenerationView` and `Rpc`, used in the robot vacuum
   firmware and the webshop example, each proven by a tool: a Spec42 generator plugin that emits
   stubs and a state machine, and a schedulability calculation.
3. **Convert the communication and technology packages** to the metadata of 5.3; delete
   `Interactions`, the placeholder `attribute def`s and the `name` attributes; update
   `conventions.md` (it currently recommends a base `name` attribute).
4. **Electronics and mechanical clean-up** in the same style.
5. **Release** with a migration note, and migrate the robot vacuum as the reference model.

## 8. Open questions

- **Keyword discovery.** Do the editors need anything to make library keywords discoverable
  (completion after `#`, hover with the specialised definition)?
- **Tool support.** Tools must implement semantic metadata as 7.27.3–7.27.4 specify (implicit
  specialisation, including for the bare form), and generators need view-scoped runs. Gaps in Spec42
  are tracked as Spec42 issues, not designed around here.
- **Strict command–query separation.** Should it be the default for new projects, or opt-in as
  proposed?
