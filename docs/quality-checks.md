# Quality Checks

Use these checks before publishing new or changed SysML libraries.

## Repository Sanity

- `rg "package |library package" domain technical`
- `rg "version: 1|severity:|category:|title:|description:" domain technical -g "*.yaml"`
- `rg "RequirementManagement|satisfy |verify |#derivation connection" domain technical`
- `powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1`

## Library Expectations

- Every library package should have at least one passing example or participate in a passing cross-domain example.
- Every rule catalog should use stable uppercase IDs, severity, category, title, and actionable description.
- Examples should import from canonical `domain/**` and `technical/**` roots.

## Parser And Semantic Validation

Use Spec42 as the semantic validation gate for all `.sysml` files under `domain/` and `technical/`.

The validation script resolves Spec42 in this order:

- `$env:SPEC42_EXE`
- `C:\Git\spec42\target\debug\spec42.exe`
- `spec42` on `PATH`

Run JSON output for automation with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-spec42.ps1 -Format json
```

Treat `domain/robotics/examples/inspection-rover/inspection-rover.sysml` as the golden path acceptance fixture.
