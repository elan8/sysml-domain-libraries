# Modeling software with SysML v2

This guide recommends mappings from software concepts to native SysML v2 and
`Elan8::Software`. These are modeling conventions, not language equivalences or
promises of code generation. Start with the engineering question and model the
detail needed to answer it. A useful architecture model does not reproduce an
entire source tree.

The initial coverage is C#, Python, Rust, C/C++, Java and TypeScript/JavaScript.
The [examples](../model/technical/software/examples/language-mappings/README.md)
pair validated SysML models with small C#, Python and Rust source counterparts.
Other languages can use the common concepts below; language-specific mappings
must be documented before tools depend on them.

## 1. Choose the level of detail

| Level | Questions | Model elements |
| --- | --- | --- |
| Architecture | Who owns responsibilities, data and interactions? | Applications, layers, modules, service contracts, datastores, ports and connections |
| Implementation | Which selected types and operations implement those responsibilities? | Definitions, usages, namespaces, attributes, actions, constraints and source links |
| Build and delivery | Which files, packages and build targets produce which artifacts? | Linked manifests and build records; explicit dependencies when relevant |
| Runtime | What executes, where, and with what lifecycle or timing? | Application/task occurrences, execution platforms, allocation, states and behavior |

A namespace is not a runtime component. A source file is not a deployed process.
A crate or assembly is not automatically an application. A logical component may
be implemented across several classes, files or build artifacts; one artifact
may implement several components. Record the mapping rather than forcing the
decompositions to match.

`SoftwareComponent` is abstract and extensible. Prefer `SoftwareApplication`,
`SoftwareLayer`, `SoftwareModule`, task types or data-resource types when their
meaning fits. A project can specialize `SoftwareComponent` directly when those
kinds do not fit. An ordinary implementation class can also use a native `part def`
without acquiring an architectural component role.

## 2. Common concepts

| Software concept | Recommended representation | Boundary to preserve |
| --- | --- | --- |
| Application | `SoftwareApplication` specialization and contextual part usage | Not necessarily one executable or process |
| Architectural layer | `SoftwareLayer`, composing constituent components | Namespace nesting alone does not enforce layering |
| Implementation module | `SoftwareModule` when there is a cohesive responsibility | Not automatically a language module, file or package |
| Namespace | Native `package` and intentional imports | Organization of names, not composition of objects |
| Stateful object/class | `part def`, with part usages for contextual objects | Specialize `SoftwareModule` only if it is also a component boundary |
| Owned child object | Composite `part` | Expresses ownership, not merely a member in source code |
| Shared/injected object | `ref part`, linked or bound to the authoritative occurrence | Does not create a second owned object |
| Scalar or structured value | `attribute` / `attribute def` | Choose value semantics, not a mapping based only on source syntax |
| Message, record or transferred data | `item` / `item def` | Does not automatically imply serialization or immutability |
| Enumeration | `enum def` and typed attributes | Numeric encodings need an implementation binding |
| Field/property | Attribute, item or part according to its semantics | A property getter can perform effects; it is not automatically a query |
| Function | `action def`, usually specializing `SoftwareOperation` | A reusable behavior definition is not a particular call |
| Method | Owned action usage typed by an operation definition | Receiver ownership and invocation context must be clear |
| Query | `QueryOperation` | No externally visible effects; a returning function is not necessarily a query |
| Command | `CommandOperation` | May mutate state or emit messages; may return results unless strict CQS is selected |
| Function/method call | Action occurrence in modeled behavior with inputs/outputs bound | Declaration, connection and allocation do not by themselves invoke behavior |
| Callable interface | `SoftwareServiceContract` with operation usages and constraints | Does not itself implement or expose the contract over a transport |
| Static/free operation | Operation definition in its namespace | No receiver instance; exact static-member code mapping needs a source binding |
| Constructor/factory | Explicit creation/lifecycle behavior when relevant | A part declaration alone is not a source-language allocation statement |
| State/lifecycle | Native states, transitions and actions | Describe relevant behavior, not every implementation branch |
| Error/result | Explicit result/error data and outcome behavior | Exceptions, panics and transport statuses need distinct treatment |
| List/map/optional data | Typed features with multiplicities and relevant constraints | Ordering, uniqueness, keys and absence semantics must also be specified |
| Datastore | `SoftwareDataStore`, with schema and access contracts | Distinct from its repository, database server and physical storage |
| Queue/channel buffer | `SoftwareQueue`, with payload/access model as needed | Capacity is message count; producer/consumer behavior remains explicit |
| Thread/task/worker | Task type only when schedulable execution and timing matter | A language async task is not automatically an RTOS task |
| Runtime/host | `ExecutionPlatform` with allocation | Component containment is not deployment |
| Source/build dependency | Native dependency, with its meaning documented | A runtime connection does not establish a compile dependency |
| Source file/symbol | `Elan8::Generation::SourceCode` metadata | A link does not verify implementation conformance |
| External library/service | `External` marker on a suitable component plus source/interface links | State the assumed contract and version outside the marker |

### Type, occurrence and behavior

Definitions describe reusable types or behaviors; usages place them in context.
An owned action usage can describe a method role, while an action occurrence in
an enclosing behavior describes a call. Bind parameters and model control/data
flow explicitly when execution matters.

The action declaration does not make a method run on startup. Use lifecycle
behavior, an explicit performed action or an allocation as appropriate to the
engineering claim. Allocation maps responsibility or deployment; it does not
replace invocation, composition or service provision.

### Classes, data and references

Decide whether identity, value semantics, ownership or transfer matters before
choosing `part`, `attribute` or `item`. A source-language class can implement an
identity-bearing object, a value object or an adapter. Its spelling does not
choose the SysML metaclass.

Use composition for owned component structure. Use references for shared stores,
injected collaborators and other independently owned objects. Model the actual
ownership relationship; neither a C# reference nor a Rust borrow automatically
means SysML composition. Native SysML visibility controls model membership, not
all language-specific access rules.

### Contracts and interfaces

A project service contract groups operation usages typed by reusable operation
definitions. A module may specialize both `SoftwareModule` and that contract to
inherit its signatures and obligations; multiple implementations can share it.
This is a semantic conformance convention, not an instruction to generate class
inheritance in every language.

An interface with data members, associated types, operators or other language
features is not necessarily a `SoftwareServiceContract`. Model the relevant
constraints and link the source interface when the callable-service abstraction
does not fit. A trait or interface implementation does not automatically expose
an RPC service.

Ports describe interaction boundaries. Grouping a service's operations does not
create one port per operation. A network endpoint may expose several services,
but the current library does not yet define the generic provided/required-service
relationship for an endpoint. `Rpc` and `InterfaceSpec` supply technology bindings;
they do not implement service exposure or dispatch.

### State, errors, concurrency and asynchronous work

Use parameters, constraints, state machines and actions to describe behavior that
matters to requirements. Model error alternatives explicitly when callers must
react differently. A language exception, a Rust `Result` and a gRPC completion
status have different semantics even if each can be represented as an outcome.

For concurrent behavior, identify execution owners, shared state, synchronization,
message delivery and ordering assumptions. An `async` method, coroutine, future
or promise does not by itself imply a thread or periodic activation. Use queues
when buffering matters; use task types when scheduling deadlines or activation
matter. Cancellation, retries, timeouts, backpressure and idempotency require
explicit contracts or behavior.

## 3. C# / .NET

Use a package for a selected namespace, a part definition for an identity-bearing
class and owned operation usages for its methods. Model properties by meaning:
stored values as attributes, shared collaborators as references, and meaningful
getter/setter behavior as operations. Records and structs require a deliberate
value-versus-identity choice; a `record class` is not automatically a SysML value.

An interface can map to a service contract when its purpose is to group callable
operations. Partial classes, extension methods, delegates, events, generics,
attributes and reflection usually remain in source unless they affect an
architectural decision or a verification obligation. Describe the relevant
behavior or constraint instead of inventing a generic SysML equivalent for each
compiler feature.

Keep the `.csproj`, NuGet identity, produced assembly and running application
distinct. Several namespaces can contribute to an assembly. Link selected model
elements to source using `ProgrammingLanguage::cSharp`; a .NET runtime can be an
execution platform. A C# `Task` return type does not alone justify a schedulable
Elan8 `Task` element.

The [C# example](../model/technical/software/examples/language-mappings/csharp/Counter.sysml)
models an `ICounter`-like callable contract and a stateful `Counter` implementation.
Its source counterpart uses a checked 32-bit integer; the model's `Integer` is an
abstraction and does not establish those finite bounds or its overflow exception.

Language references: [types](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/object-oriented/)
and [namespaces](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/program-structure/namespaces).
The mappings above are this library's recommendations.

## 4. Python

Use a package for a selected source module or package namespace, action definitions
for functions, and part definitions/owned actions for relevant classes and methods.
Promote a module to `SoftwareModule` only when it represents a component boundary;
its namespace alone does not create a runtime component.

A script is source that is executed with an entry behavior. Model that entry
action and, if useful, an application occurrence allocated to a Python execution
platform. The same `.py` file can also be imported as a module. `main` is a common
function convention, not a required function name; `__main__` identifies top-level
execution. Keep import-time side effects distinct from explicitly called behavior.

Dataclasses, dictionaries and typed records map according to their data semantics.
Dynamic typing, duck typing, decorators, generators, context managers, monkey
patching and metaclasses generally stay in source. Model their contracts, yielded
items or lifecycle effects when relevant. `asyncio` coroutines are not automatically
separate threads. A distribution package/wheel and an import package are separate
build and namespace concepts.

The [Python example](../model/technical/software/examples/language-mappings/python/Report.sysml)
separates a pure formatting function, a printing entry action, a source-module
namespace, an application occurrence and its runtime allocation.

Language references: [modules and packages](https://docs.python.org/3.13/tutorial/modules.html)
and [`__main__`](https://docs.python.org/3.13/library/__main__.html).
The mappings above are this library's recommendations.

## 5. Rust

A Cargo package contains one or more crates. A crate is a compilation unit;
its source modules organize names and visibility. Model selected crate/module
namespaces using packages, and link Cargo manifests/build artifacts separately.
Do not create an owned runtime part for every `mod` declaration.

Free functions and associated functions without a receiver map to operation
definitions in an appropriate namespace. A method with a `self`, `&self` or
`&mut self` receiver can map to an owned action usage. An `impl` block is not an
additional runtime component. Define a part or data type for a selected struct
according to its identity, ownership and value semantics.

A trait can map to a callable contract when that abstraction fits; associated
types, constants, blanket implementations and trait bounds require further source
bindings or explicit constraints when modeled. Rust borrowing, lifetimes,
`Send`/`Sync`, pinning and memory safety are not proven by SysML `ref` features or
composition. An `&self` method with interior mutability may have effects, so it is
not automatically a `QueryOperation`. Model `Result`, `Option`, panic and async
cancellation separately when their distinctions matter.

The [Rust example](../model/technical/software/examples/language-mappings/rust/Counter.sysml)
distinguishes a Cargo package, crate root, nested source module, free function,
struct and receiver methods. `Integer` abstracts the source's checked `i32`;
the model does not establish overflow/panic semantics.

Language references: [packages and crates](https://doc.rust-lang.org/book/ch07-01-packages-and-crates.html)
and [associated items and methods](https://doc.rust-lang.org/reference/items/associated-items.html).
The mappings above are this library's recommendations.

## 6. C and C++

For C, use operation definitions for functions and attributes/items for relevant
data. Model a module as `SoftwareModule` when a cohesive responsibility exists;
a `.c` translation unit or header is primarily a source/build artifact. Function
pointers and callback tables can implement a callable contract; link the concrete
signature and callback behavior when these matter.

For C++, namespaces map to packages; relevant identity-bearing classes map to part
definitions and methods to owned operation usages. Value-oriented structs/classes
can instead map to data/value definitions. Explicitly model resource lifecycle
when construction/destruction and RAII affect correctness. Pointers, references,
smart pointers, templates, overload resolution, object layout and binary ABI are
not encoded merely by `part`, `ref` or specialization.

Keep translation units, C++ language modules, static/shared libraries, executables
and runtime processes distinct. Headers and includes do not define runtime
communication. Build/link dependencies may be recorded separately from component
connections. Use `ProgrammingLanguage::c` or `cpp` for source links.

Language references: the [C committee draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf)
for functions and translation units, and the
[C++ working draft](https://isocpp.org/files/papers/N4971.pdf) for translation units,
modules and classes. These mappings do not claim complete C/C++ language or ABI coverage.

## 7. Java

Use packages for namespace organization, part definitions for selected
identity-bearing classes and owned operations for methods. Callable interfaces
can use service contracts. Records, enums and other data types map according to
their value and transfer semantics. Inheritance in the architecture expresses
semantic specialization; it is not a complete model of JVM dispatch or type erasure.

Keep source packages, Java platform modules, Maven/Gradle projects, JARs and running
JVMs separate. Model a JVM as an execution platform when deployment matters.
Threads, executor services, futures and virtual threads need explicit execution
and concurrency assumptions; an asynchronous return value alone is insufficient.
Annotations, reflection, serialization and generics stay linked to source unless
a concrete analysis needs additional bindings. Use `ProgrammingLanguage::java`.

Language reference: [Java object-oriented programming](https://dev.java/learn/language/oop/).

## 8. TypeScript and JavaScript

Use packages for selected ECMAScript module namespaces, action definitions for
functions and relevant data/part definitions for objects and classes. Export/import
dependencies are distinct from runtime connections. An npm package, workspace,
bundle, browser application and Node.js process need not share one decomposition.

TypeScript's structural interfaces and type aliases do not necessarily represent
runtime objects or services. A callable contract can use `SoftwareServiceContract`;
a data shape can use an item/value definition. Union/discriminated-union behavior,
optional fields and runtime validation require explicit data constraints where
important. Type erasure means a compile-time type alone is not runtime validation.

Promises, callbacks and event-loop scheduling need explicit ordering and error
assumptions. They do not automatically imply concurrent threads. Keep decorators,
prototypes, module loader details and bundler transformations in source/build
bindings unless an engineering question requires them in the model.

Use `ProgrammingLanguage::typeScript` for TypeScript source links. The current
enumeration has no JavaScript literal; link the source path without setting that
optional field rather than labeling JavaScript as TypeScript.

Language references: [TypeScript modules](https://www.typescriptlang.org/docs/handbook/2/modules.html)
and the [handbook](https://www.typescriptlang.org/docs/handbook/).

## 9. Source, build and deployment traceability

Use `SourceCode` for paths and optional language/entry-point information. The
examples use paths relative to the repository root; that is a repository convention,
not a native SysML path-resolution rule. An entry-point string identifies the
source callable used by the example, not a verified symbol-resolution relationship.
`InterfaceSpec` links external contracts such as Protobuf. Pin external revisions
when reproducibility matters.

Keep build manifests authoritative: `.csproj`, `pyproject.toml`, `Cargo.toml`,
CMake/Meson files, Maven/Gradle files and `package.json` describe different build
ecosystems. Link them in project documentation and record meaningful dependencies.
Do not pretend a package import models a build or that a component's owned part
automatically creates a source-project reference.

The library currently has no generic build-artifact, package-manager identity or
compiler-option schema. Project-specific metadata/records may fill a concrete
need, but must be identified as project extensions. Likewise, generic parameters,
exact numeric representations, binary layout, overload identities and compiler
semantics do not have complete reusable mappings here. Other languages such as
Go, Kotlin, Swift or functional languages can use the shared architectural
vocabulary; dedicated language bindings and examples remain future work.

## 10. Review and validation

1. State whether the model describes architecture, implementation, build or runtime.
2. Identify authoritative contracts, source files, manifests and versions.
3. Check ownership versus references, especially injected/shared resources.
4. Distinguish operation definitions, owned method roles and actual calls.
5. Check interface payloads, direction, behavior and failure assumptions.
6. Separate source dependencies, runtime interaction and deployment.
7. Validate the complete SysML workspace and inspect important relationships.
8. Compile/test linked code where available; do not infer conformance from links.

Run `python scripts/validate_spec42.py` from the repository root. It checks the
language examples alongside the other model sources using the pinned Spec42
release; advisory domain-completeness diagnostics are filtered. Native source
checks and their limits are documented in the examples' README. Neither language
validation nor passing source tests proves equivalence between model and code.
