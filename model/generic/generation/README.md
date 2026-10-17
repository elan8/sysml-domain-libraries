# Generation Library

`Elan8::Generation` says what a tool should produce from a model and how, without the tool guessing
from names or folders.

- `CodeGenerationView`: one code generation run. The view exposes what is generated; annotate it
  with `CodeGeneration` (target language, state-machine style, strict command-query separation).
- `FormalVerification`: on a verification case, the technique (model checking, theorem proving,
  abstract interpretation) and an optional bound. The case's subject and objective say what is
  checked against what.
- `SourceCode` and `InterfaceSpec`: links from model elements to the code that implements them and
  to the documents that specify their interfaces (`.proto`, OpenAPI, AsyncAPI, CAN DBC, JSON
  Schema).

Which elements a generator acts on follows from their type (`Elan8::Software`), their relationships
(owned, exhibited or allocated behaviour) and the view's exposure. See
[docs/library-design.md](../../../docs/library-design.md), section 4.
