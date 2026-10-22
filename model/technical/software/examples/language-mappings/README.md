# Software language mappings

Read the [software modeling guide](../../../../../docs/software-modeling.md) for
the mapping conventions and limitations. These examples pair architectural and
selected implementation concepts with small source counterparts. The SysML
models specify selected signatures, ownership and relationships; they do not
reproduce source bodies or establish model/code equivalence.

| Example | What it demonstrates | Source/build counterpart |
| --- | --- | --- |
| [C#](csharp/Counter.sysml) | Callable contract, stateful class, inherited method roles and application composition | [Counter.cs](csharp/Counter.cs), a library snippet with an interface and implementation |
| [Python](python/Report.sysml) | Source-module namespace, pure function, script entry action, application and runtime allocation | [report.py](python/report.py), importable or executable |
| [Rust](rust/Counter.sysml) | Crate/module namespaces, free function, struct and receiver methods | [Cargo.toml](rust/Cargo.toml), [lib.rs](rust/src/lib.rs) and [arithmetic.rs](rust/src/arithmetic.rs) |

`SourceCode.path` uses repository-root-relative paths in these models. Naming
correspondence is a documented convention, not an automatic symbol binding:

| Model member | Source member |
| --- | --- |
| `CSharpMapping::CounterContract::read` | `Demo.ICounter.Read`, implemented by `Demo.Counter.Read` |
| `CSharpMapping::CounterContract::add` | `Demo.ICounter.Add`, implemented by `Demo.Counter.Add` |
| `PythonMapping::ReportModule::FormatReport` | `report.format_report` |
| `PythonMapping::ReportModule::RunReport` | `report.main` |
| `RustMapping::CounterCrate::Arithmetic::Double` | `arithmetic::double` |
| `RustMapping::CounterCrate::Counter::read` | `Counter::read(&self)` |
| `RustMapping::CounterCrate::Counter::add` | `Counter::add(&mut self, amount)` |

The counter sources use checked fixed-width integers. Their SysML `Integer`
parameters are mathematical abstractions: bounds, overflow exceptions/panics,
thread safety and complete lifecycle semantics are outside these models.

## Validation

From the repository root:

```sh
python scripts/validate_spec42.py
python -B model/technical/software/examples/language-mappings/python/report.py demo
```

The Python command should print `Report: demo`. Importing the module should not
print a report; its `main` action represents execution with an already parsed
label, while command-line parsing remains in source.

With Rust installed, compile/run the source's unit tests using `rustc --test`
or `cargo test --offline` against the example manifest. Put test/build output in
a scratch directory outside the library's active model tree. Cargo can also
create a lock file; that build artifact is not part of the architectural model.

`Counter.cs` is a library snippet, not an executable or a complete .NET project.
Compile it within a compatible C# project when an SDK is available. The validation
script checks its linked SysML model; it does not invoke a C# compiler.

No C/C++, Java or TypeScript source fixtures are included yet. Their guide
chapters describe recommended mappings rather than validated language-specific
code generation. Examples are excluded from the published KPAR, as are the
repository's other examples.
