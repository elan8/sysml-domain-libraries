# Quality Checks

Use these checks before publishing new or changed SysML libraries.

## Repository Sanity

- `rg "package |library package" model`
- `python3 scripts/validate_spec42.py`

## Library Expectations

- Every library package should have at least one passing example or participate in a passing cross-domain example.
- Examples should import vocabulary from `model/technical/` and `model/generic/`.
- Do **not** import Elan8 Method packages (`mbse-methodology`) from this repository.
- Do not add declarative rule catalogs unless they are backed by executable validation logic.

## Parser And Semantic Validation

The [software language examples](../model/technical/software/examples/language-mappings/README.md)
are included in the complete workspace check. They also include source counterparts;
run native compiler/interpreter checks separately where available. A source link
or successful SysML validation alone does not verify model/code equivalence.

The [interaction examples](../model/technical/software/examples/interactions/README.md)
also participate in the workspace check. Inspect referential RPC typing, service
bindings, transport allocations and connection ends in semantic exports. A
Protobuf compiler/schema check is separate from SysML validation; broker delivery
guarantees and generated transport behavior are not verified by these fixtures.

Use Spec42 as the semantic validation gate for all `.sysml` files under `model/`.
By default, the repository script filters Spec42 diagnostics with `source = domain`; those are modeling-completeness checks from Spec42's bundled domain libraries, not SysML syntax or semantic validity checks for this repository.

The validation script resolves Spec42 in this order:

- `--spec42` argument
- `SPEC42_EXE` environment variable
- `spec42` on `PATH`
- download and cache the release pinned in [`.spec42-version`](../.spec42-version) (under a user cache directory, once per machine per version)

Run JSON output for automation with:

```sh
python3 scripts/validate_spec42.py --format json
```

There is no business-domain library in this repository. `model/examples/bench-instrument/` composes mechanical, electronics, software, and procurement. The software examples are `model/technical/software/examples/webshop/` (services, operations, bindings, generation and verification), `model/technical/software/examples/motor-controller/` (tasks, timing and deployment), and `model/technical/software/examples/layered-application/` (applications, layers, modules, service contracts and a persistent datastore referenced by its repository).

To inspect Spec42's bundled domain-completeness diagnostics as advisory output, run:

```sh
python3 scripts/validate_spec42.py --include-domain-diagnostics
```
