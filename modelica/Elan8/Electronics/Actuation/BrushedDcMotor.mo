within Elan8.Electronics.Actuation;
model BrushedDcMotor "Elan8::Electronics::Actuation::BrushedDcMotor: armature resistance and inductance in series with a back-EMF, driving a rotor"
  parameter Modelica.Units.SI.Resistance armatureResistance "SysML: armatureResistance";
  parameter Modelica.Units.SI.Inductance armatureInductance "SysML: armatureInductance";
  parameter Real torqueConstant(unit = "N.m/A") "SysML: torqueConstant. Torque per armature current, which in SI is also the back-EMF constant in V.s/rad";
  parameter Modelica.Units.SI.Inertia rotorInertia "SysML: rotorInertia";
  Modelica.Electrical.Analog.Interfaces.PositivePin terminal1 "SysML: terminal1";
  Modelica.Electrical.Analog.Interfaces.NegativePin terminal2 "SysML: terminal2";
  Modelica.Mechanics.Rotational.Interfaces.Flange_b mechanicalOutput "SysML: mechanicalOutput";
protected
  Modelica.Electrical.Analog.Basic.Resistor winding(R = armatureResistance);
  Modelica.Electrical.Analog.Basic.Inductor armature(L = armatureInductance);
  Modelica.Electrical.Analog.Basic.RotationalEMF emf(k = torqueConstant);
  Modelica.Mechanics.Rotational.Components.Inertia rotor(J = rotorInertia);
equation
  connect(terminal1, winding.p);
  connect(winding.n, armature.p);
  connect(armature.n, emf.p);
  connect(emf.n, terminal2);
  connect(emf.flange, rotor.flange_a);
  connect(rotor.flange_b, mechanicalOutput);
end BrushedDcMotor;
