# Systems engineering roles and views

The source package [SystemsEngineering](../model/generic/systems-engineering/SystemsEngineering.sysml) is publicly exported through `Elan8::SystemsEngineering`.

| Abstract definition | Intended role |
|---|---|
| `SystemSpecification` | Observable system boundary contract |
| `SystemArchitecture` | Proposed realization through child contracts and responsibilities |
| `SystemIntegration` | Configuration selecting compatible constituent designs |

`SystemArchitecture` specializes `SystemSpecification`; `SystemIntegration` specializes `SystemArchitecture`. Project definitions must additionally specialize the actual system-specific contract/architecture. The [recursive example](../model/generic/systems-engineering/examples/recursive-system/RecursiveSystem.sysml) shows this through two levels.

```sysml
private import Elan8::SystemsEngineering::*;

part def DriveSpecification :> SystemSpecification;
part def DriveArchitecture :> DriveSpecification, SystemArchitecture;
part def MachineSpecification :> SystemSpecification;
part def MachineArchitecture :> MachineSpecification, SystemArchitecture {
    part drive : DriveSpecification;
}
part def MachineIntegration :> MachineArchitecture, SystemIntegration {
    part redefines drive : DriveArchitecture;
}
```

Four reusable view definitions also specialize `StandardViewDefinitions::GeneralView`: `ContextView`, `SpecificationView`, `ArchitectureView` and `IntegrationView`. Their inherited filters select boundary content or structural parts/ports/connections, including bindings and flows. Context views exclude view usages to avoid selecting themselves. Consumers supply the `expose` roots; the methodology documents exact recipes.

```sysml
view selectedDesign : Elan8::SystemsEngineering::IntegrationView {
    expose RecursiveSystemExample::selectedMachine;
}
```

These definitions support stable role identification by tools and engineers. They do not add custom properties or wrap native SysML requirements, behavior, allocation, verification or views. No automated methodology diagnostics are implemented by this library change.

Tooling must distinguish the most specific method role: integrations are also architectures and specifications by inheritance. A contract-only rule such as “no internal constituent decomposition” must exclude architecture and integration definitions. An actual contract specialization is a separate check from role conformance.

Parent-local obligations require explicit reconciliation against the selected child design, including interfaces, behavior and quantities. A compatible type is insufficient evidence. A leaf may select an architecture directly; use a child integration when deeper selections must be included.

This addition is available in the working tree and will be included by the existing KPAR bundle rules. It has not been published as a new library release. Consumers must pin a source revision or a released artifact containing it. Do not load a copied local role package alongside this dependency.

## Local validation

Checked on 21 October 2026 with Spec42 0.56.0 and the installed 2026-04 standard-library distribution (Kernel 1.0.0 / SysML 2.0.0). Managed domain/method archives were disabled. The source baseline is commit `1161c0c79bdde014c049b045201a416bfa2819ea` plus these uncommitted additions.

- All 36 library model documents, including the two-level recursive example: zero errors or warnings.
- Methodology starter and elevator consumer, loading this library through `--library-path`: 7 and 9 workspace documents respectively, zero errors. After adding the four reusable view types, each consumer produces four `view_type_non_standard` warnings in Spec42 0.56.0; the views are discovered and prepared correctly. SysML v2.0 Part 1 §7.26.2 supports view specialization and inherited filters.
- Consumer semantic export: project contracts resolve to shared roles; actual contract/architecture specialization and inherited child redefinitions remain distinct and resolved.
- Local KPAR built using the existing release exclusions; inspected for exactly one `SystemsEngineering.sysml` and no examples. The temporary archive was removed after validation; no version or release was published.

Equivalent library check (supply your own executable and pinned standard-library path):

```powershell
spec42 --disable-kpar-library domain --disable-kpar-library method `
  --stdlib-path /path/to/standard-library/kpar check ./model --workspace-root ./model
```

Language and relationship checks do not prove contextual engineering compatibility or execute verification cases. The roles introduce no automatic methodology checker.
