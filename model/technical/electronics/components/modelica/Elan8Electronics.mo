within ;
package Elan8Electronics "Ideal circuit elements for Elan8::Electronics::Components"
  connector Pin "Across potential and through current. Names match the SysML ports."
    Real v "Potential";
    flow Real i "Current into the component";
  end Pin;

  model Resistor "Components::Resistor"
    parameter Real resistance(unit = "Ohm") "resistance";
    Pin terminal1;
    Pin terminal2;
    Real i "Current from terminal1 to terminal2";
  equation
    terminal1.v - terminal2.v = resistance * i;
    terminal1.i = i;
    terminal2.i = -i;
  end Resistor;

  model Capacitor "Components::Capacitor. initialVoltage is this model's authored rest state."
    parameter Real capacitance(unit = "F") "capacitance";
    parameter Real initialVoltage(unit = "V") = 0 "Capacitor voltage at the start of the run";
    Pin terminal1;
    Pin terminal2;
    Real v(start = initialVoltage, fixed = true) "terminal1.v - terminal2.v";
    Real i "Current into terminal1";
  equation
    i = capacitance * der(v);
    terminal1.v - terminal2.v = v;
    terminal1.i = i;
    terminal2.i = -i;
  end Capacitor;

  model Inductor "Components::Inductor. Current starts at 0."
    parameter Real inductance(unit = "H") "inductance";
    Pin terminal1;
    Pin terminal2;
    Real i(start = 0, fixed = true) "Current from terminal1 to terminal2";
  equation
    terminal1.v - terminal2.v = inductance * der(i);
    terminal1.i = i;
    terminal2.i = -i;
  end Inductor;

  model VoltageSource "Components::VoltageSource"
    parameter Real sourceVoltage(unit = "V") "sourceVoltage";
    Pin terminal1;
    Pin terminal2;
    Real i "Current out of terminal1";
  equation
    terminal1.v - terminal2.v = sourceVoltage;
    terminal1.i = i;
    terminal2.i = -i;
  end VoltageSource;

  model CurrentSource "Components::CurrentSource"
    parameter Real sourceCurrent(unit = "A") "sourceCurrent";
    Pin terminal1;
    Pin terminal2;
  equation
    terminal1.i = sourceCurrent;
    terminal2.i = -sourceCurrent;
  end CurrentSource;

  model Ground "Components::Ground"
    Pin terminal;
  equation
    terminal.v = 0;
  end Ground;
end Elan8Electronics;
