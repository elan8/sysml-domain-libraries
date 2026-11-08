within Elan8.Electronics.Components;
model CurrentSource "Elan8::Electronics::Components::CurrentSource: constant current from terminal1 through the source to terminal2"
  parameter Modelica.Units.SI.Current sourceCurrent "SysML: sourceCurrent";
  Modelica.Electrical.Analog.Interfaces.Pin terminal1 "SysML: terminal1";
  Modelica.Electrical.Analog.Interfaces.Pin terminal2 "SysML: terminal2";
protected
  Modelica.Electrical.Analog.Sources.ConstantCurrent element(I = sourceCurrent);
equation
  connect(terminal1, element.p);
  connect(element.n, terminal2);
end CurrentSource;
