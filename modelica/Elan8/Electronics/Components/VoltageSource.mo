within Elan8.Electronics.Components;
model VoltageSource "Elan8::Electronics::Components::VoltageSource: constant voltage, terminal1 positive"
  parameter Modelica.Units.SI.Voltage sourceVoltage "SysML: sourceVoltage";
  Modelica.Electrical.Analog.Interfaces.Pin terminal1 "SysML: terminal1";
  Modelica.Electrical.Analog.Interfaces.Pin terminal2 "SysML: terminal2";
protected
  Modelica.Electrical.Analog.Sources.ConstantVoltage element(V = sourceVoltage);
equation
  connect(terminal1, element.p);
  connect(element.n, terminal2);
end VoltageSource;
