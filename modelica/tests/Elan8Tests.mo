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
end Elan8Tests;
