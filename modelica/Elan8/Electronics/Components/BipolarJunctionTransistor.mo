within Elan8.Electronics.Components;
model BipolarJunctionTransistor "Elan8::Electronics::Components::BipolarJunctionTransistor: Ebers-Moll (MSL NPN/PNP)"
  parameter BipolarJunctionPolarity polarity = BipolarJunctionPolarity.npn "SysML: polarity";
  parameter Real currentGain "SysML: currentGain (forward beta)";
  Modelica.Electrical.Analog.Interfaces.Pin base "SysML: base";
  Modelica.Electrical.Analog.Interfaces.Pin collector "SysML: collector";
  Modelica.Electrical.Analog.Interfaces.Pin emitter "SysML: emitter";
protected
  Modelica.Electrical.Analog.Semiconductors.NPN npn(Bf = currentGain) if polarity == BipolarJunctionPolarity.npn;
  Modelica.Electrical.Analog.Semiconductors.PNP pnp(Bf = currentGain) if polarity == BipolarJunctionPolarity.pnp;
equation
  connect(base, npn.B);
  connect(collector, npn.C);
  connect(emitter, npn.E);
  connect(base, pnp.B);
  connect(collector, pnp.C);
  connect(emitter, pnp.E);
end BipolarJunctionTransistor;
