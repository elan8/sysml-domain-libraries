# Library design

Status: proposal. Nothing in `model/` changes until this document is agreed. The SysML snippets
have been checked with Spec42 against the standard library.

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

### 3.5 Keywords through semantic metadata

Frequently used concepts get a user-defined keyword (SysML v2 7.27.4): a `metadata def` specialising
`SemanticMetadata` with a `baseType`. Declaring with the keyword implicitly specialises the base, so
models read naturally and tools still see a typed fact:

```sysml
#operation action def ReadWheelSpeed { in wheel : WheelId; out speed : AngularVelocityValue; }
#task part def MotorControlLoop { … }
```

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
| Code generation | `SoftwareComponent`, `SoftwareOperation`, interaction ports, payload `item def`s, `state def`s | ownership, `exhibit`, `allocate`; a `CodeGenerationView` | `CodeGeneration`, technology bindings (`Rpc`, `Topic`, `HttpRoute`, …), `SourceCode` |
| Formal verification | `state def`s, interaction ports, constraints | a `verification def` whose subject is the component and whose objective names the requirements; `VerificationMethod` = analysis | `FormalVerification { technique; bound; }` |
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
| `Elan8::Electronics` | components with typed terminals and ratings, power, sensing, actuation, buses | keep; remove placeholder types (`SignalKind`, `VoltageClass`, …) and `name` attributes; make bus and interface kinds typed ports |
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

- **Electronics catalogue.** Should catalogue-level parts (`CeramicCapacitor`, `BldcMotor`,
  `CatalogMcu`) stay in the core or move to an optional catalogue package?
- **Keywords.** Which concepts deserve a keyword (`#operation`, `#task`, `#component`), and do the
  editors need anything to make keywords discoverable?
- **Spec42 support.** Semantic metadata keywords and view-scoped generation must be supported by the
  generator API; this needs a Spec42 issue once the design is agreed.
