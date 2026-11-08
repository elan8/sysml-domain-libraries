within Elan8.Electronics.Components;
model Capacitor "Elan8::Electronics::Components::Capacitor: ideal linear capacitor"
  parameter Modelica.Units.SI.Capacitance capacitance "SysML: capacitance";
  Modelica.Electrical.Analog.Interfaces.Pin terminal1 "SysML: terminal1 (positive of a PolarizedCapacitor)";
  Modelica.Electrical.Analog.Interfaces.Pin terminal2 "SysML: terminal2 (negative of a PolarizedCapacitor)";
  Modelica.Units.SI.Voltage v(start = 0) "Voltage from terminal1 to terminal2";
equation
  terminal1.i + terminal2.i = 0;
  v = terminal1.v - terminal2.v;
  capacitance*der(v) = terminal1.i;
end Capacitor;
