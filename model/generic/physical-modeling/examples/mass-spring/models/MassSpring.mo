within ;
package Example "Modelica side of the mass-spring example (MassSpringSimulation)"
  model MassSpring "Undamped translational mass-spring, released 0.1 m from rest"
    parameter Real mass(unit = "kg") = 1 "SysML: mass";
    parameter Real stiffness(unit = "N/m") = 10 "SysML: stiffness";
    Real s(unit = "m", start = 0.1, fixed = true) "Position; the scenario output `position`";
    Real v(unit = "m/s", start = 0, fixed = true) "Velocity";
  equation
    der(s) = v;
    mass*der(v) = -stiffness*s;
    annotation(experiment(StopTime = 5));
  end MassSpring;
end Example;
