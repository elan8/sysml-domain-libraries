within Elan8.Electronics.Power;
model PrimaryCell "Elan8::Electronics::Power::PrimaryCell: constant open-circuit voltage behind an internal resistance, with the usable charge drawn down"
  parameter Modelica.Units.SI.Voltage nominalVoltage "SysML: nominalVoltage (open-circuit voltage)";
  parameter Modelica.Units.SI.Resistance internalResistance "SysML: internalResistance";
  parameter Modelica.Units.SI.ElectricCharge nominalCapacity "SysML: nominalCapacity";
  parameter Real usableCapacityFactor = 1 "SysML: usableCapacityFactor";
  Modelica.Electrical.Analog.Interfaces.Pin positive "SysML: positive";
  Modelica.Electrical.Analog.Interfaces.Pin negative "SysML: negative";
  Modelica.Units.SI.ElectricCharge remainingCharge(start = nominalCapacity*usableCapacityFactor, fixed = true) "Usable charge not yet delivered";
  Modelica.Units.SI.Current current "Current delivered from the positive terminal";
equation
  positive.i = -current;
  negative.i = current;
  positive.v - negative.v = nominalVoltage - internalResistance*current;
  der(remainingCharge) = -current;
end PrimaryCell;
