# SysML Domain Libraries

[![License](https://img.shields.io/github/license/elan8/sysml-domain-libraries)](LICENSE)

This repository provides reusable SysML v2 **vocabulary** for things in the system:
- `generic/` — cross-domain foundation 
- `technical/` — business-agnostic technical capabilities (software, electronics, mechanical).

The cross-domain [systems engineering roles and views](docs/systems-engineering.md)
support recursive specification, architecture and integration modeling through
`Elan8::SystemsEngineering`, with four reusable filtered GeneralView specializations.
This source addition is not yet a published release.

What belongs in these libraries, and how tools use them, is set out in [docs/library-design.md](docs/library-design.md).

The [document composition vocabulary](docs/documents.md), exported as
`Elan8::Documents`, supplies renderer-independent metadata for document views,
sections, prose, figures and tables. This source addition is not yet released.

The [software vocabulary](model/technical/software/README.md) includes compositional
`SoftwareApplication` and `SoftwareLayer` types. Layers can carry an optional
`#RRGGBB` color hint for renderers. It also distinguishes implementation modules,
service contracts, datastores and queues. These additions are not yet released.

The [software modeling guide](docs/software-modeling.md) covers common software
concepts and mappings for C#, Python, Rust, C/C++, Java and TypeScript/JavaScript,
with linked SysML/source examples for C#, Python and Rust.
The [interaction guide](docs/software-interactions.md) covers gRPC service ports,
HTTP transport mappings, Kafka and message-bus patterns.

## Validation

```sh
python3 scripts/validate_spec42.py
```

## Releasing

The libraries ship as a KPAR built by `spec42 bundle`, without the docs, scripts and examples:

```sh
python3 scripts/bundle_kpar.py
```

Both scripts use the Spec42 release pinned in [`.spec42-version`](.spec42-version). To release,
set the version in [`.project.json`](.project.json) and push a matching `v<version>` tag;
the release workflow validates, bundles and publishes the archive.

## License

MIT. See [LICENSE](LICENSE).
