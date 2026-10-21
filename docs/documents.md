# Document composition

`Elan8::Documents` supplies generic metadata for native SysML v2 view usages.
The defining package is `Documents`, publicly imported by `Elan8`, following
the domain library's namespace convention. Consumers identify resolved metadata
definitions in `Documents`, regardless of the importing namespace.

```sysml
package ProjectDocuments {
    private import Elan8::Documents::*;
    view specification {
        @Document { title = "System specification"; number = "SRS-001"; }
        view introduction {
            @Section { title = "Introduction"; }
            doc /* Purpose and scope of the system. */
        }
    }
}
```

A document is a view annotated with `Document`; nested views define sections in
authored order. `Section` supplies a title, `Prose` references Markdown, `Figure`
references SVG, `Table` selects columns over exposed elements, and
`RequirementTable` supplies a requirement-table preset. These metadata definitions
do not duplicate the engineering model or prescribe a rendering engine.

Configure `sysml-domain-libraries/model` as a library path for both editors and
consumers. Migrate former `Doc42::*` imports to `Elan8::Documents::*` and remove
vendored Doc42 libraries. The public definitions preserve the fields of the
former v0.4.0 library, including organization, prose, figures and table selectors.
A consumer must support these metadata identities; older releases expecting
`Doc42::Document` need to be upgraded with the model.

The language baseline remains OMG SysML v2.0; these are domain metadata,
not additions to the language syntax. Validate with `scripts/validate_spec42.py`.
