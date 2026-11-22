within Elan8.Electronics.Actuation;
model StepperMotor "Elan8::Electronics::Actuation::StepperMotor: two-phase hybrid stepper motor on two current-regulated full bridges, driven by a commanded field angle"
  parameter Modelica.Units.SI.Resistance phaseResistance "SysML: phaseResistance. Per phase";
  parameter Modelica.Units.SI.Inductance phaseInductance "SysML: phaseInductance. Per phase";
  parameter Real torqueConstant(unit = "N.m/A") "SysML: torqueConstant. Torque per phase current at the best rotor angle, which in SI is also the back-EMF constant in V.s/rad: the holding torque over the rated current";
  parameter Real rotorTeeth "SysML: rotorTeeth. Number of rotor teeth, a positive whole number: the electrical cycles per revolution, 50 for a 1.8 degree motor";
  parameter Modelica.Units.SI.Torque detentTorque = 0 "SysML: detentTorque. Peak torque with the windings unpowered, four periods per electrical cycle";
  parameter Modelica.Units.SI.Inertia rotorInertia "SysML: rotorInertia";
  parameter Modelica.Units.SI.Voltage supplyVoltage "SysML: supplyVoltage. Of the two full bridges";
  parameter Modelica.Units.SI.Resistance chopperGain = 500 "SysML: chopperGain. Gain of the current regulation, a transresistance: the bridge voltage per ampere of current error, before it saturates at the supply";
  Modelica.Mechanics.Rotational.Interfaces.Flange_b mechanicalOutput "SysML: mechanicalOutput";
  input Real fieldAngle(unit = "rad") "Electrical angle of the stator field the driver commands; one full step is a quarter of a cycle";
  input Real currentCommand(unit = "A") "Peak phase current the driver regulates to";
  Real rotorAngle(unit = "rad") "Mechanical angle of the rotor";
  Real rotorSpeed(unit = "rad/s") "Mechanical speed of the rotor";
  Real currentA(unit = "A", start = 0, fixed = true) "Current of phase A";
  Real currentB(unit = "A", start = 0, fixed = true) "Current of phase B";
  Real voltageA(unit = "V") "Voltage the bridge applies to phase A";
  Real voltageB(unit = "V") "Voltage the bridge applies to phase B";
  Real electricalTorque(unit = "N.m") "Air-gap torque on the rotor: torqueConstant (-iA sin(p theta) + iB cos(p theta)) less the detent torque";
protected
  Modelica.Mechanics.Rotational.Components.Inertia rotor(J = rotorInertia);
  Modelica.Mechanics.Rotational.Sources.Torque torque;
  Real rotorElectricalAngle(unit = "rad") = rotorTeeth * rotor.phi;
  Real referenceA(unit = "A") = currentCommand * cos(fieldAngle);
  Real referenceB(unit = "A") = currentCommand * sin(fieldAngle);
equation
  rotorAngle = rotor.phi;
  rotorSpeed = rotor.w;
  // Each bridge adds the voltage drop of the reference current to a proportional correction, and the
  // supply limits it; the average over a switching period is taken, so no chopping ripple is modelled.
  voltageA = max(-supplyVoltage, min(supplyVoltage, phaseResistance * referenceA + chopperGain * (referenceA - currentA)));
  voltageB = max(-supplyVoltage, min(supplyVoltage, phaseResistance * referenceB + chopperGain * (referenceB - currentB)));
  // The magnet flux linked by the phases is psi (cos(p theta), sin(p theta)), so the back-EMFs are its derivative.
  phaseInductance * der(currentA) = voltageA - phaseResistance * currentA + torqueConstant * rotor.w * sin(rotorElectricalAngle);
  phaseInductance * der(currentB) = voltageB - phaseResistance * currentB - torqueConstant * rotor.w * cos(rotorElectricalAngle);
  electricalTorque = torqueConstant * (-currentA * sin(rotorElectricalAngle) + currentB * cos(rotorElectricalAngle))
    - detentTorque * sin(4 * rotorElectricalAngle);
  torque.tau = electricalTorque;
  connect(torque.flange, rotor.flange_a);
  connect(rotor.flange_b, mechanicalOutput);
end StepperMotor;
