within Elan8.Mechanical;
model WheeledInvertedPendulum "Elan8::Mechanical::Balancing::WheeledInvertedPendulum: a body balanced on one axle with two wheels that roll without slipping, in the vertical plane"
  parameter Modelica.Units.SI.Mass bodyMass "SysML: bodyMass. Everything above the axle: rider, cargo and the vehicle's body";
  parameter Modelica.Units.SI.Length bodyCenterHeight "SysML: bodyCenterHeight. Height of the body's centre of mass above the axle";
  parameter Modelica.Units.SI.Inertia bodyInertia "SysML: bodyInertia. Of the body about its centre of mass, for rotation about the axle direction";
  parameter Modelica.Units.SI.Mass wheelMass "SysML: wheelMass. Both wheels and what moves with them along the ground";
  parameter Modelica.Units.SI.Inertia wheelInertia "SysML: wheelInertia. Both wheels and the rotors turning with them, about the axle";
  parameter Modelica.Units.SI.Length wheelRadius "SysML: wheelRadius. Rolling radius";
  parameter Real wheelDamping(unit = "N.m.s/rad") = 0 "SysML: wheelDamping. Viscous torque between the wheels and the body, per relative angular velocity (bearing and rolling losses)";
  parameter Modelica.Units.SI.Acceleration gravity = 9.81 "SysML: gravity";
  Modelica.Mechanics.Rotational.Interfaces.Flange_a drive "SysML: drive. Torque on the wheels from the motors; the body feels the opposite torque. Its angle is the wheels' rotation relative to the body";
  Modelica.Units.SI.Position position(start = 0, fixed = true) "SysML: position. Of the axle along the ground";
  Modelica.Units.SI.Velocity velocity(start = 0, fixed = true) "SysML: velocity";
  Modelica.Units.SI.Angle pitch(start = 0, fixed = true) "SysML: pitch. Of the body from the vertical, positive when leaning forward";
  Modelica.Units.SI.AngularVelocity pitchRate(start = 0, fixed = true) "SysML: pitchRate";
  Modelica.Units.SI.Torque wheelTorque "Net torque the motors exert on the wheels, after the damping loss";
  Modelica.Units.SI.Energy energy "Kinetic plus potential energy of the whole system, for checking";
protected
  Modelica.Units.SI.Inertia inertiaTranslation = wheelMass + bodyMass + wheelInertia / wheelRadius ^ 2 "Mass seen along the ground, wheels' rotation included";
  Modelica.Units.SI.Inertia coupling = bodyMass * bodyCenterHeight * cos(pitch) "Coupling between ground acceleration and pitch";
  Modelica.Units.SI.Inertia inertiaPitch = bodyMass * bodyCenterHeight ^ 2 + bodyInertia "Pitch inertia about the axle";
  Modelica.Units.SI.Force groundForce "Generalised force on the position: the centrifugal term and the wheel torque over the radius";
  Modelica.Units.SI.Torque pitchTorque "Generalised force on the pitch: gravity and the opposite of the wheel torque";
  Real determinant(unit = "kg2.m2") "Determinant of the mass matrix, always positive";
equation
  der(position) = velocity;
  der(pitch) = pitchRate;
  drive.phi = position / wheelRadius - pitch;
  wheelTorque = drive.tau - wheelDamping * (velocity / wheelRadius - pitchRate);
  // Lagrange's equations with the generalised coordinates position and pitch, the wheels rolling without
  // slipping and the motors acting between the wheels and the body:
  //   inertiaTranslation a + coupling alpha = groundForce,   coupling a + inertiaPitch alpha = pitchTorque.
  // They are solved for the accelerations by Cramer's rule; the determinant is positive for any pitch.
  groundForce = bodyMass * bodyCenterHeight * sin(pitch) * pitchRate ^ 2 + wheelTorque / wheelRadius;
  pitchTorque = bodyMass * gravity * bodyCenterHeight * sin(pitch) - wheelTorque;
  determinant = inertiaTranslation * inertiaPitch - coupling ^ 2;
  der(velocity) = (inertiaPitch * groundForce - coupling * pitchTorque) / determinant;
  der(pitchRate) = (inertiaTranslation * pitchTorque - coupling * groundForce) / determinant;
  energy = 0.5 * inertiaTranslation * velocity ^ 2
    + bodyMass * bodyCenterHeight * cos(pitch) * velocity * pitchRate
    + 0.5 * inertiaPitch * pitchRate ^ 2
    + bodyMass * gravity * bodyCenterHeight * cos(pitch);
end WheeledInvertedPendulum;
