"""Check the MSL inventory against representative source declarations."""

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "scripts"))
from check_modelica_bindings import msl_catalog


class CatalogTest(unittest.TestCase):
    def test_public_models_and_blocks_in_files_and_nested_packages(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Sources.mo").write_text(
                '''within Modelica.Blocks;
package Sources
  block Step
    annotation(Documentation(info="Example code:\n  model InsideDocumentation"));
  end Step;
  block Alias = Step;
  partial block PartialStep
  end PartialStep;
  package Examples
    model Demo
    end Demo;
  end Examples;
protected
  model Hidden
  end Hidden;
public
  model Assembly
    model LocalPart
    end LocalPart;
  equation
    value = compute(
      function UserFunctions.callback(k=1));
  end Assembly;
  package Nested
    /* block InsideComment */
    block Gain
    end Gain;
  end Nested;
end Sources;
''',
                encoding="utf-8",
            )
            (root / "Resistor.mo").write_text(
                "within Modelica.Electrical.Analog.Basic;\nmodel Resistor\nend Resistor;\n",
                encoding="utf-8",
            )
            resources = root / "Resources"
            resources.mkdir()
            (resources / "Probe.mo").write_text(
                "within Modelica.Mechanics;\nmodel Probe\nend Probe;\n",
                encoding="utf-8",
            )
            self.assertEqual(
                msl_catalog(root),
                {
                    "Modelica.Blocks.Sources.Alias",
                    "Modelica.Blocks.Sources.Assembly",
                    "Modelica.Blocks.Sources.Nested.Gain",
                    "Modelica.Blocks.Sources.Step",
                    "Modelica.Electrical.Analog.Basic.Resistor",
                },
            )


if __name__ == "__main__":
    unittest.main()
