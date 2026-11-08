within Elan8.Electronics.Components;
model Resistor "Elan8::Electronics::Components::Resistor: ideal linear resistor"
  parameter Modelica.Units.SI.Resistance resistance "SysML: resistance";
  Modelica.Electrical.Analog.Interfaces.Pin terminal1 "SysML: terminal1";
  Modelica.Electrical.Analog.Interfaces.Pin terminal2 "SysML: terminal2";
protected
  Modelica.Electrical.Analog.Basic.Resistor element(R = resistance);
equation
  connect(terminal1, element.p);
  connect(element.n, terminal2);
end Resistor;
