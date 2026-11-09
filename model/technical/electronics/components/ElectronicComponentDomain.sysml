package Components {
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import ISQ::*;
    private import ScalarValues::*;

    attribute def ComponentPackage :> String {
        doc /* Package or footprint designation, for example 0603 or SOT-23. */
    }

    attribute def ComponentTolerance :> Real {
        doc /* Relative tolerance expressed as a fraction, for example 0.05 for 5%. */
    }

    abstract part def BoardLevelElectronicComponent :> ElectronicsComponent {
        attribute packageType : ComponentPackage;
    }

    abstract part def TwoTerminalElectronicComponent
        :> BoardLevelElectronicComponent {
        port terminal1 : ElectricalTerminalPort;
        port terminal2 : ElectricalTerminalPort;
    }

    abstract part def ThreeTerminalElectronicComponent
        :> BoardLevelElectronicComponent {
        port terminal1 : ElectricalTerminalPort;
        port terminal2 : ElectricalTerminalPort;
        port terminal3 : ElectricalTerminalPort;
    }

    abstract part def PassiveElectronicComponent
        :> BoardLevelElectronicComponent;

    abstract part def TwoTerminalPassiveComponent
        :> PassiveElectronicComponent, TwoTerminalElectronicComponent;

    part def Resistor :> TwoTerminalPassiveComponent {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Basic.Resistor";
            parameters = ("resistance=R");
            pins = ("terminal1=p", "terminal2=n");
        }
        attribute resistance : ResistanceValue;
        attribute tolerance : ComponentTolerance;
        attribute ratedPower : PowerValue;
        attribute maximumWorkingVoltage : ElectricPotentialValue;
    }

    part def Capacitor :> TwoTerminalPassiveComponent {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Basic.Capacitor";
            parameters = ("capacitance=C");
            pins = ("terminal1=p", "terminal2=n");
        }
        attribute capacitance : CapacitanceValue;
        attribute tolerance : ComponentTolerance;
        attribute ratedVoltage : ElectricPotentialValue;
    }

    part def CeramicCapacitor :> Capacitor;

    part def PolarizedCapacitor :> Capacitor {
        port positive : ElectricalTerminalPort :> terminal1;
        port negative : ElectricalTerminalPort :> terminal2;
    }

    part def ElectrolyticCapacitor :> PolarizedCapacitor;
    part def TantalumCapacitor :> PolarizedCapacitor;

    part def Inductor :> TwoTerminalPassiveComponent {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Basic.Inductor";
            parameters = ("inductance=L");
            pins = ("terminal1=p", "terminal2=n");
        }
        attribute inductance : InductanceValue;
        attribute tolerance : ComponentTolerance;
        attribute ratedCurrent : ElectricCurrentValue;
    }

    part def Fuse :> TwoTerminalPassiveComponent {
        attribute ratedCurrent : ElectricCurrentValue;
        attribute ratedVoltage : ElectricPotentialValue;
    }

    part def VoltageSource :> TwoTerminalElectronicComponent {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Sources.ConstantVoltage";
            parameters = ("sourceVoltage=V");
            pins = ("terminal1=p", "terminal2=n");
        }
        doc /*
         * Ideal zero-internal-impedance source. Distinct from the
         * system-level power architecture parts in
         * Elan8::Electronics::Power (BatteryPack, VoltageRegulator, ...),
         * which model real supply hardware rather than an idealized
         * schematic primitive.
         */
        attribute sourceVoltage : ElectricPotentialValue;
    }

    part def CurrentSource :> TwoTerminalElectronicComponent {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Sources.ConstantCurrent";
            parameters = ("sourceCurrent=I");
            pins = ("terminal1=p", "terminal2=n");
        }
        attribute sourceCurrent : ElectricCurrentValue;
    }

    part def Ground :> BoardLevelElectronicComponent {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Basic.Ground";
            pins = ("terminal=p");
        }
        doc /* Reference node of a circuit. */
        port terminal : ElectricalTerminalPort;
    }

    part def CrystalResonator :> TwoTerminalPassiveComponent {
        attribute resonantFrequency : FrequencyValue;
        attribute loadCapacitance : CapacitanceValue;
    }

    abstract part def SemiconductorDevice
        :> BoardLevelElectronicComponent;

    part def Diode
        :> SemiconductorDevice, TwoTerminalElectronicComponent {
        port anode : ElectricalTerminalPort :> terminal1;
        port cathode : ElectricalTerminalPort :> terminal2;
        attribute forwardVoltage : ElectricPotentialValue;
        attribute maximumReverseVoltage : ElectricPotentialValue;
        attribute maximumForwardCurrent : ElectricCurrentValue;
    }

    part def SchottkyDiode :> Diode;

    part def ZenerDiode :> Diode {
        attribute zenerVoltage : ElectricPotentialValue;
    }

    part def LightEmittingDiode :> Diode {
        attribute dominantWavelength : LengthValue;
    }

    abstract part def Transistor
        :> SemiconductorDevice, ThreeTerminalElectronicComponent;

    abstract part def BipolarJunctionTransistor :> Transistor {
        doc /* A bipolar junction transistor: an NpnTransistor or a PnpTransistor. */
        port base : ElectricalTerminalPort :> terminal1;
        port collector : ElectricalTerminalPort :> terminal2;
        port emitter : ElectricalTerminalPort :> terminal3;
        attribute currentGain : Real;
        attribute maximumCollectorEmitterVoltage : ElectricPotentialValue;
        attribute maximumCollectorCurrent : ElectricCurrentValue;
    }

    part def NpnTransistor :> BipolarJunctionTransistor {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Semiconductors.NPN";
            parameters = ("currentGain=Bf");
            pins = ("base=B", "collector=C", "emitter=E");
        }
    }

    part def PnpTransistor :> BipolarJunctionTransistor {
        @Elan8::PhysicalModeling::ModelicaModel {
            className = "Modelica.Electrical.Analog.Semiconductors.PNP";
            parameters = ("currentGain=Bf");
            pins = ("base=B", "collector=C", "emitter=E");
        }
    }

    enum def FieldEffectChannel {
        nChannel;
        pChannel;
    }

    abstract part def FieldEffectTransistor :> Transistor {
        port gate : ElectricalTerminalPort :> terminal1;
        port drain : ElectricalTerminalPort :> terminal2;
        port source : ElectricalTerminalPort :> terminal3;
        attribute channel : FieldEffectChannel;
        attribute maximumDrainSourceVoltage : ElectricPotentialValue;
        attribute maximumDrainCurrent : ElectricCurrentValue;
    }

    part def Mosfet :> FieldEffectTransistor;
    part def JunctionFieldEffectTransistor :> FieldEffectTransistor;

    part def IntegratedCircuit :> SemiconductorDevice {
        port pins : ElectricalTerminalPort[2..*];
    }
}
