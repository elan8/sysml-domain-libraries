within ;
package Elan8Tests "Circuits built from Elan8 classes, checked by check.py against references derived without a simulator"
  model CellResistor "PrimaryCell under a constant 10 kOhm load"
    Elan8.Electronics.Power.PrimaryCell cell(nominalVoltage = 3.0, internalResistance = 15,
      nominalCapacity = 220e-3*3600, usableCapacityFactor = 0.8);
    Elan8.Electronics.Components.Resistor load(resistance = 10000);
    Elan8.Electronics.Components.Ground ground;
  equation
    connect(cell.positive, load.terminal1);
    connect(load.terminal2, cell.negative);
    connect(cell.negative, ground.terminal);
    annotation(experiment(StopTime = 10));
  end CellResistor;

  model RcCharge "VoltageSource charging a 1 uF capacitor through 1 kOhm from 0 V"
    Elan8.Electronics.Components.VoltageSource source(sourceVoltage = 3.0);
    Elan8.Electronics.Components.Resistor resistor(resistance = 1000);
    Elan8.Electronics.Components.Capacitor capacitor(capacitance = 1e-6, v(fixed = true));
    Elan8.Electronics.Components.Ground ground;
  equation
    connect(source.terminal1, resistor.terminal1);
    connect(resistor.terminal2, capacitor.terminal1);
    connect(capacitor.terminal2, source.terminal2);
    connect(source.terminal2, ground.terminal);
    annotation(experiment(StopTime = 5e-3));
  end RcCharge;

  model NpnDriver "Low-side NPN: base from 3 V through 47 kOhm, collector to a 3 V rail through 1 kOhm"
    Elan8.Electronics.Components.VoltageSource rail(sourceVoltage = 3.0);
    Elan8.Electronics.Components.VoltageSource drive(sourceVoltage = 3.0);
    Elan8.Electronics.Components.Resistor base(resistance = 47000);
    Elan8.Electronics.Components.Resistor load(resistance = 1000);
    Elan8.Electronics.Components.BipolarJunctionTransistor transistor(currentGain = 200);
    Elan8.Electronics.Components.Ground ground;
  equation
    connect(drive.terminal1, base.terminal1);
    connect(base.terminal2, transistor.base);
    connect(rail.terminal1, load.terminal1);
    connect(load.terminal2, transistor.collector);
    connect(transistor.emitter, ground.terminal);
    connect(rail.terminal2, ground.terminal);
    connect(drive.terminal2, ground.terminal);
    annotation(experiment(StopTime = 1e-3));
  end NpnDriver;

  model PnpDriver "The NPN driver mirrored: emitter at 3 V, base to 0 V through 47 kOhm, collector to ground through 1 kOhm"
    Elan8.Electronics.Components.VoltageSource rail(sourceVoltage = 3.0);
    Elan8.Electronics.Components.Resistor base(resistance = 47000);
    Elan8.Electronics.Components.Resistor load(resistance = 1000);
    Elan8.Electronics.Components.BipolarJunctionTransistor transistor(
      polarity = Elan8.Electronics.Components.BipolarJunctionPolarity.pnp, currentGain = 200);
    Elan8.Electronics.Components.Ground ground;
  equation
    connect(rail.terminal1, transistor.emitter);
    connect(transistor.base, base.terminal1);
    connect(base.terminal2, ground.terminal);
    connect(transistor.collector, load.terminal1);
    connect(load.terminal2, ground.terminal);
    connect(rail.terminal2, ground.terminal);
    annotation(experiment(StopTime = 1e-3));
  end PnpDriver;

  model CellCurrentSource "PrimaryCell delivering a constant 3 mA"
    Elan8.Electronics.Power.PrimaryCell cell(nominalVoltage = 3.0, internalResistance = 15,
      nominalCapacity = 220e-3*3600, usableCapacityFactor = 0.8);
    Elan8.Electronics.Components.CurrentSource load(sourceCurrent = 3e-3);
    Elan8.Electronics.Components.Ground ground;
  equation
    connect(cell.positive, load.terminal1);
    connect(load.terminal2, cell.negative);
    connect(cell.negative, ground.terminal);
    annotation(experiment(StopTime = 100));
  end CellCurrentSource;
end Elan8Tests;
