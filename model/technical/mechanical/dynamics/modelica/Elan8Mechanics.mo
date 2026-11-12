within ;
package Elan8Mechanics "Pendulum bound from Elan8::Mechanical::Dynamics"
  connector Flange "Hinge-axis angle and the torque about that axis"
    Real phi "Angle of this side of the hinge";
    flow Real tau "Torque into the component";
  end Flange;

  model InertialFrame "Dynamics::InertialFrame. The hinge axis is fixed in the lab."
    Flange flange;
  equation
    flange.phi = 0;
  end InertialFrame;

  model Pendulum "Dynamics::Pendulum. angle is from the downward vertical."
    parameter Real mass(unit = "kg") "mass";
    parameter Real length(unit = "m") "length";
    parameter Real gravity(unit = "m/s2") "gravity";
    parameter Real releaseAngle(unit = "rad") "releaseAngle";
    Flange pivot;
    Real angle(start = releaseAngle, fixed = true) "From the downward vertical";
    Real angularVelocity(start = 0, fixed = true) "Angular velocity, released from rest";
  equation
    der(angle) = angularVelocity;
    // The hinge reaction acts at the pivot, so it has no moment about it.
    pivot.tau = 0;
    mass * length * der(angularVelocity) = -mass * gravity * sin(angle - pivot.phi);
  end Pendulum;
end Elan8Mechanics;
