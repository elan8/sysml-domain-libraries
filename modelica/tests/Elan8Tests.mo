within ;
package Elan8Tests "Circuits of the classes the Elan8 part definitions bind to, with the bound names, checked by check.py against references derived without a simulator"
  model CellResistor "PrimaryCell under a constant 10 kOhm load"
    Elan8.Electronics.Power.PrimaryCell cell(nominalVoltage = 3.0, internalResistance = 15,
      nominalCapacity = 220e-3*3600, usableCapacityFactor = 0.8);
    Modelica.Electrical.Analog.Basic.Resistor load(R = 10000);
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(cell.positive, load.p);
    connect(load.n, cell.negative);
    connect(cell.negative, ground.p);
    annotation(experiment(StopTime = 10));
  end CellResistor;

  model RcCharge "VoltageSource charging a 1 uF capacitor through 1 kOhm from 0 V"
    Modelica.Electrical.Analog.Sources.ConstantVoltage source(V = 3.0);
    Modelica.Electrical.Analog.Basic.Resistor resistor(R = 1000);
    Modelica.Electrical.Analog.Basic.Capacitor capacitor(C = 1e-6, v(start = 0, fixed = true));
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(source.p, resistor.p);
    connect(resistor.n, capacitor.p);
    connect(capacitor.n, source.n);
    connect(source.n, ground.p);
    annotation(experiment(StopTime = 5e-3));
  end RcCharge;

  model NpnDriver "Low-side NPN: base from 3 V through 47 kOhm, collector to a 3 V rail through 1 kOhm"
    Modelica.Electrical.Analog.Sources.ConstantVoltage rail(V = 3.0);
    Modelica.Electrical.Analog.Sources.ConstantVoltage drive(V = 3.0);
    Modelica.Electrical.Analog.Basic.Resistor base(R = 47000);
    Modelica.Electrical.Analog.Basic.Resistor load(R = 1000);
    Modelica.Electrical.Analog.Semiconductors.NPN transistor(Bf = 200);
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(drive.p, base.p);
    connect(base.n, transistor.B);
    connect(rail.p, load.p);
    connect(load.n, transistor.C);
    connect(transistor.E, ground.p);
    connect(rail.n, ground.p);
    connect(drive.n, ground.p);
    annotation(experiment(StopTime = 1e-3));
  end NpnDriver;

  model PnpDriver "The NPN driver mirrored: emitter at 3 V, base to 0 V through 47 kOhm, collector to ground through 1 kOhm"
    Modelica.Electrical.Analog.Sources.ConstantVoltage rail(V = 3.0);
    Modelica.Electrical.Analog.Basic.Resistor base(R = 47000);
    Modelica.Electrical.Analog.Basic.Resistor load(R = 1000);
    Modelica.Electrical.Analog.Semiconductors.PNP transistor(Bf = 200);
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(rail.p, transistor.E);
    connect(transistor.B, base.p);
    connect(base.n, ground.p);
    connect(transistor.C, load.p);
    connect(load.n, ground.p);
    connect(rail.n, ground.p);
    annotation(experiment(StopTime = 1e-3));
  end PnpDriver;

  model CellCurrentSource "PrimaryCell delivering a constant 3 mA"
    Elan8.Electronics.Power.PrimaryCell cell(nominalVoltage = 3.0, internalResistance = 15,
      nominalCapacity = 220e-3*3600, usableCapacityFactor = 0.8);
    Modelica.Electrical.Analog.Sources.ConstantCurrent load(I = 3e-3);
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(cell.positive, load.p);
    connect(load.n, cell.negative);
    connect(cell.negative, ground.p);
    annotation(experiment(StopTime = 100));
  end CellCurrentSource;
  model MassSpringDamper "Translational.Mass released 0.1 m from a wall, on a 100 N/m spring and a 4 N.s/m damper"
    Modelica.Mechanics.Translational.Components.Fixed wall(s0 = 0);
    Modelica.Mechanics.Translational.Components.Spring spring(c = 100, s_rel0 = 0);
    Modelica.Mechanics.Translational.Components.Damper damper(d = 4);
    Modelica.Mechanics.Translational.Components.Mass body(m = 1, s(start = 0.1, fixed = true),
      v(start = 0, fixed = true));
  equation
    connect(wall.flange, spring.flange_a);
    connect(spring.flange_b, body.flange_a);
    connect(wall.flange, damper.flange_a);
    connect(damper.flange_b, body.flange_a);
    annotation(experiment(StopTime = 3));
  end MassSpringDamper;
  model DcMotorSpinUp "BrushedDcMotor from rest on 12 V, with a load inertia on its shaft"
    Modelica.Electrical.Analog.Sources.ConstantVoltage supply(V = 12);
    Elan8.Electronics.Actuation.BrushedDcMotor motor(armatureResistance = 2, armatureInductance = 5e-3,
      torqueConstant = 0.05, rotorInertia = 1e-4);
    Modelica.Mechanics.Rotational.Components.Inertia load(J = 2e-4);
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(supply.p, motor.terminal1);
    connect(motor.terminal2, supply.n);
    connect(supply.n, ground.p);
    connect(motor.mechanicalOutput, load.flange_a);
    annotation(experiment(StopTime = 0.1));
  end DcMotorSpinUp;

  model PmsmLockedRotor "PermanentMagnetSynchronousMotor with its rotor held, on constant dq voltages"
    Elan8.Electronics.Actuation.PermanentMagnetSynchronousMotor motor(statorResistance = 0.5,
      statorInductanceD = 1e-3, statorInductanceQ = 2e-3, permanentMagnetFlux = 0.05, polePairs = 4,
      rotorInertia = 1e-3);
    Modelica.Mechanics.Rotational.Components.Fixed rotorHold;
  equation
    motor.vd = 3;
    motor.vq = 5;
    connect(motor.mechanicalOutput, rotorHold.flange);
    annotation(experiment(StopTime = 0.02));
  end PmsmLockedRotor;

  model PmsmFreeSpin "PermanentMagnetSynchronousMotor from rest on constant dq voltages, salient, no load"
    Elan8.Electronics.Actuation.PermanentMagnetSynchronousMotor motor(statorResistance = 0.5,
      statorInductanceD = 1e-3, statorInductanceQ = 2e-3, permanentMagnetFlux = 0.05, polePairs = 4,
      rotorInertia = 1e-3);
    Modelica.Mechanics.Rotational.Components.Inertia load(J = 1e-3);
  equation
    motor.vd = -2;
    motor.vq = 10;
    connect(motor.mechanicalOutput, load.flange_a);
    annotation(experiment(StopTime = 0.1));
  end PmsmFreeSpin;

  model BldcLockedSine "ThreePhaseBldcMotor with its rotor held at 0.3 rad, sinusoidal, on constant duties"
    Elan8.Electronics.Actuation.ThreePhaseBldcMotor motor(phaseResistance = 0.5, phaseInductance = 1e-3,
      permanentMagnetFlux = 0.01, polePairs = 4, emfShape = 0, rotorInertia = 1e-3, dcLinkVoltage = 24);
    Modelica.Mechanics.Rotational.Components.Fixed rotorHold(phi0 = 0.3);
  equation
    motor.dutyA = 0.7;
    motor.dutyB = 0.4;
    motor.dutyC = 0.5;
    connect(motor.mechanicalOutput, rotorHold.flange);
    annotation(experiment(StopTime = 0.01));
  end BldcLockedSine;

  model BldcLockedTrapezoid "As BldcLockedSine with trapezoidal back-EMF"
    Elan8.Electronics.Actuation.ThreePhaseBldcMotor motor(phaseResistance = 0.5, phaseInductance = 1e-3,
      permanentMagnetFlux = 0.01, polePairs = 4, emfShape = 1, rotorInertia = 1e-3, dcLinkVoltage = 24);
    Modelica.Mechanics.Rotational.Components.Fixed rotorHold(phi0 = 0.3);
  equation
    motor.dutyA = 0.7;
    motor.dutyB = 0.4;
    motor.dutyC = 0.5;
    connect(motor.mechanicalOutput, rotorHold.flange);
    annotation(experiment(StopTime = 0.01));
  end BldcLockedTrapezoid;

  model BldcFreeSpinSine "Sinusoidal ThreePhaseBldcMotor from rest on constant dq voltages, rotated to phase duties (d axis along minus cos, q along sin of the electrical angle, the magnet axis for back-EMF proportional to sin)"
    Elan8.Electronics.Actuation.ThreePhaseBldcMotor motor(phaseResistance = 0.5, phaseInductance = 1.5e-3,
      permanentMagnetFlux = 0.05, polePairs = 4, emfShape = 0, rotorInertia = 1e-3, dcLinkVoltage = 100);
    Modelica.Mechanics.Rotational.Components.Inertia load(J = 1e-3);
  protected
    constant Real pi = Modelica.Constants.pi;
    parameter Real vd = -2;
    parameter Real vq = 10;
  equation
    motor.dutyA = 0.5 + (vq * sin(motor.electricalAngle) - vd * cos(motor.electricalAngle)) / motor.dcLinkVoltage;
    motor.dutyB = 0.5 + (vq * sin(motor.electricalAngle - 2 * pi / 3) - vd * cos(motor.electricalAngle - 2 * pi / 3)) / motor.dcLinkVoltage;
    motor.dutyC = 0.5 + (vq * sin(motor.electricalAngle + 2 * pi / 3) - vd * cos(motor.electricalAngle + 2 * pi / 3)) / motor.dcLinkVoltage;
    connect(motor.mechanicalOutput, load.flange_a);
    annotation(experiment(StopTime = 0.1));
  end BldcFreeSpinSine;

  model DriveWheel "Motor, 10:1 gearbox and a 30 mm rolling wheel driving a 1 kg body"
    Modelica.Electrical.Analog.Sources.ConstantVoltage supply(V = 12);
    Elan8.Electronics.Actuation.BrushedDcMotor motor(armatureResistance = 2, armatureInductance = 5e-3,
      torqueConstant = 0.05, rotorInertia = 1e-4);
    Modelica.Mechanics.Rotational.Components.IdealGear gearbox(ratio = 10);
    Modelica.Mechanics.Rotational.Components.IdealRollingWheel wheel(radius = 0.03);
    Modelica.Mechanics.Translational.Components.Mass body(m = 1);
    Modelica.Electrical.Analog.Basic.Ground ground;
  equation
    connect(supply.p, motor.terminal1);
    connect(motor.terminal2, supply.n);
    connect(supply.n, ground.p);
    connect(motor.mechanicalOutput, gearbox.flange_a);
    connect(gearbox.flange_b, wheel.flangeR);
    connect(wheel.flangeT, body.flange_a);
    annotation(experiment(StopTime = 0.1));
  end DriveWheel;

  model TorsionalOscillator "Inertia released 0.1 rad from a fixed support on a torsional spring and damper"
    Modelica.Mechanics.Rotational.Components.Fixed support(phi0 = 0);
    Modelica.Mechanics.Rotational.Components.Spring spring(c = 1, phi_rel0 = 0);
    Modelica.Mechanics.Rotational.Components.Damper damper(d = 0.04);
    Modelica.Mechanics.Rotational.Components.Inertia rotor(J = 0.01, phi(start = 0.1, fixed = true),
      w(start = 0, fixed = true));
  equation
    connect(support.flange, spring.flange_a);
    connect(spring.flange_b, rotor.flange_a);
    connect(support.flange, damper.flange_a);
    connect(damper.flange_b, rotor.flange_a);
    annotation(experiment(StopTime = 3));
  end TorsionalOscillator;

  model TorqueSpinUp "A constant 0.5 N.m torque on a 0.25 kg.m2 inertia, from rest"
    Modelica.Mechanics.Rotational.Sources.ConstantTorque source(tau_constant = 0.5);
    Modelica.Mechanics.Rotational.Components.Inertia rotor(J = 0.25);
    Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor;
    Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor;
    Modelica.Mechanics.Rotational.Sensors.AccSensor accelerationSensor;
  equation
    connect(source.flange, rotor.flange_a);
    connect(rotor.flange_b, angleSensor.flange);
    connect(rotor.flange_b, speedSensor.flange);
    connect(rotor.flange_b, accelerationSensor.flange);
    annotation(experiment(StopTime = 2));
  end TorqueSpinUp;

  model ForceDrivenMass "Constant force plus a force step on a mass with position sensing"
    Modelica.Mechanics.Translational.Sources.ConstantForce bias(f_constant = 2);
    Modelica.Mechanics.Translational.Sources.ForceStep drive(offsetForce = 0, stepForce = 4, startTime = 0.25);
    Modelica.Mechanics.Translational.Components.Mass body(m = 2, s(start = 0, fixed = true),
      v(start = 0, fixed = true));
    Modelica.Mechanics.Translational.Sensors.PositionSensor positionSensor;
  equation
    connect(bias.flange, body.flange_a);
    connect(drive.flange, body.flange_a);
    connect(body.flange_b, positionSensor.flange);
    annotation(experiment(StopTime = 1));
  end ForceDrivenMass;

  model CommandedLinearMotion "A 6 N signal force driving a 2 kg mass from rest"
    Modelica.Mechanics.Translational.Sources.Force drive;
    Modelica.Mechanics.Translational.Components.Mass body(m = 2, s(start = 0, fixed = true),
      v(start = 0, fixed = true));
    Modelica.Mechanics.Translational.Sensors.PositionSensor positionSensor;
    Modelica.Mechanics.Translational.Sensors.SpeedSensor speedSensor;
    Modelica.Mechanics.Translational.Sensors.AccSensor accelerationSensor;
  equation
    drive.f = 6;
    connect(drive.flange, body.flange_a);
    connect(body.flange_b, positionSensor.flange);
    connect(body.flange_b, speedSensor.flange);
    connect(body.flange_b, accelerationSensor.flange);
    annotation(experiment(StopTime = 1));
  end CommandedLinearMotion;
end Elan8Tests;
