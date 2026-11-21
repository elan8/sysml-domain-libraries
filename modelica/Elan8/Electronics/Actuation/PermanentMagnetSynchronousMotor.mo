within Elan8.Electronics.Actuation;
model PermanentMagnetSynchronousMotor "Elan8::Electronics::Actuation::PermanentMagnetSynchronousMotor: dq-frame model driven by stator voltages in the rotor frame"
  parameter Modelica.Units.SI.Resistance statorResistance "SysML: statorResistance. Per phase";
  parameter Modelica.Units.SI.Inductance statorInductanceD "SysML: statorInductanceD. Direct axis";
  parameter Modelica.Units.SI.Inductance statorInductanceQ "SysML: statorInductanceQ. Quadrature axis";
  parameter Modelica.Units.SI.MagneticFlux permanentMagnetFlux "SysML: permanentMagnetFlux. Rotor magnet flux linked by a phase, peak";
  parameter Real polePairs "SysML: polePairs. Number of pole pairs, a positive whole number";
  parameter Modelica.Units.SI.Inertia rotorInertia "SysML: rotorInertia";
  Modelica.Mechanics.Rotational.Interfaces.Flange_b mechanicalOutput "SysML: mechanicalOutput";
  input Real vd(unit = "V") "Direct-axis stator voltage";
  input Real vq(unit = "V") "Quadrature-axis stator voltage";
  Real id(unit = "A", start = 0, fixed = true) "Direct-axis stator current";
  Real iq(unit = "A", start = 0, fixed = true) "Quadrature-axis stator current";
  Real electricalTorque(unit = "N.m") "Air-gap torque on the rotor, 3/2 p (flux iq + (Ld - Lq) id iq)";
  Real electricalSpeed(unit = "rad/s") "Rotor speed times the pole pairs";
protected
  Modelica.Mechanics.Rotational.Components.Inertia rotor(J = rotorInertia);
  Modelica.Mechanics.Rotational.Sources.Torque torque;
equation
  electricalSpeed = polePairs * rotor.w;
  statorInductanceD * der(id) = vd - statorResistance * id + electricalSpeed * statorInductanceQ * iq;
  statorInductanceQ * der(iq) = vq - statorResistance * iq - electricalSpeed * (statorInductanceD * id + permanentMagnetFlux);
  electricalTorque = 1.5 * polePairs * (permanentMagnetFlux * iq + (statorInductanceD - statorInductanceQ) * id * iq);
  torque.tau = electricalTorque;
  connect(torque.flange, rotor.flange_a);
  connect(rotor.flange_b, mechanicalOutput);
end PermanentMagnetSynchronousMotor;
