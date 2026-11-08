within Elan8.Electronics.Components;
model Ground "Elan8::Electronics::Components::Ground: zero-potential reference"
  Modelica.Electrical.Analog.Interfaces.Pin terminal "SysML: terminal";
equation
  terminal.v = 0;
end Ground;
