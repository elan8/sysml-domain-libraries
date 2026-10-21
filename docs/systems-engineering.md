# Systems engineering roles and views

The source package [SystemsEngineering](../model/generic/systems-engineering/SystemsEngineering.sysml) is publicly exported through `Elan8::SystemsEngineering`.

| Abstract definition | Intended role |
|---|---|
| `SystemSpecification` | Observable system boundary contract |
| `SystemArchitecture` | Proposed realization through child contracts and responsibilities |
| `SystemIntegration` | Configuration selecting compatible constituent designs |

The three generic role definitions are independent abstract part definitions. A project architecture specializes its actual specification plus `SystemArchitecture`; a project integration specializes its actual architecture plus `SystemIntegration`. The [recursive example](../model/generic/systems-engineering/examples/recursive-system/RecursiveSystem.sysml) shows this through two levels.

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

Tooling must distinguish the most specific method role. Although the generic markers are independent, a project integration inherits the architecture/specification markers through its actual architecture/contract chain. Resolve WB before GB before BB. A contract-only rule such as “no structural parts” must exclude architecture and integration definitions. Actual contract refinement is separate from role classification.

Parent-local obligations require explicit reconciliation against the selected child design, including interfaces, behavior and quantities. A compatible type is insufficient evidence. A leaf may select an architecture directly; use a child integration when deeper selections must be included.

This addition is available in the working tree and will be included by the existing KPAR bundle rules. It has not been published as a new library release. Consumers must pin a source revision or a released artifact containing it. Do not load a copied local role package alongside this dependency.

The library metadata now targets **0.5.0**. The methodology 0.3.0 candidate carries a frozen local KPAR of that version with a checksum lock, so its default validation does not require this mutable checkout. Neither candidate has been published by these changes.

## Local validation

Checked on 21 October 2026 with Spec42 0.56.0 and the installed 2026-04 standard-library distribution (Kernel 1.0.0 / SysML 2.0.0). Managed domain/method archives were disabled. Roles/views were checkpointed in `646eef3`; the independent-marker revision is a subsequent working-tree change and was revalidated across the library and consumers.

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
