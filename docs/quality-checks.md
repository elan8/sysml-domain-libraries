# Quality Checks

Use these checks before publishing new or changed SysML libraries.

## Repository Sanity

- `rg "package |library package" domain technical generic`
- `rg "Elan8Requirement|@StatusInfo|@RequirementRole|satisfy |verify |#derivation connection" domain technical generic`
- `powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1`

## Library Expectations

- Every library package should have at least one passing example or participate in a passing cross-domain example.
- Examples should import vocabulary from `domain/**`, `technical/**`, and `generic/units/**`.
- Requirements / method packages: import `Elan8*` from sibling `mbse-methodology/library` only (no SE packages in this repo).
- Do not add declarative rule catalogs unless they are backed by executable validation logic.

## Parser And Semantic Validation

Use Spec42 as the semantic validation gate for all `.sysml` files under `domain/`, `technical/`, and `generic/`.
The validate script **requires** sibling `../mbse-methodology/library` so Elan8 Method packages resolve.
By default, the repository script filters Spec42 diagnostics with `source = domain`; those are modeling-completeness checks from Spec42's bundled domain libraries, not SysML syntax or semantic validity checks for this repository.

The validation script resolves Spec42 in this order:

- `$env:SPEC42_EXE`
- `C:\Git\elan8\spec42\target\debug\spec42.exe`
- `C:\Git\spec42\target\debug\spec42.exe`
- `spec42` on `PATH`

Run JSON output for automation with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1 -Format json
```

Treat `domain/robotics/examples/inspection-rover/inspection-rover.sysml` as the golden path acceptance fixture.

To inspect Spec42's bundled domain-completeness diagnostics as advisory output, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1 -IncludeDomainDiagnostics
```
