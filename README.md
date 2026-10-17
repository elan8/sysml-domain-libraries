# SysML Domain Libraries

[![License](https://img.shields.io/github/license/elan8/sysml-domain-libraries)](LICENSE)

This repository provides reusable SysML v2 **vocabulary** for things in the system:
- `generic/` — cross-domain foundation 
- `technical/` — business-agnostic technical capabilities (software, electronics, mechanical).

What belongs in these libraries, and how tools use them, is set out in [docs/library-design.md](docs/library-design.md).

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
