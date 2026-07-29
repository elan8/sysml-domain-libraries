package ElectronicComponentDomain {
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;
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
        attribute resistance : ResistanceValue;
        attribute tolerance : ComponentTolerance;
        attribute ratedPower : PowerValue;
        attribute maximumWorkingVoltage : ElectricPotentialValue;
    }

    part def Capacitor :> TwoTerminalPassiveComponent {
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
        attribute inductance : InductanceValue;
        attribute tolerance : ComponentTolerance;
        attribute ratedCurrent : ElectricCurrentValue;
    }

    part def Fuse :> TwoTerminalPassiveComponent {
        attribute ratedCurrent : ElectricCurrentValue;
        attribute ratedVoltage : ElectricPotentialValue;
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

    enum def BipolarJunctionPolarity {
        npn;
        pnp;
    }

    part def BipolarJunctionTransistor :> Transistor {
        port base : ElectricalTerminalPort :> terminal1;
        port collector : ElectricalTerminalPort :> terminal2;
        port emitter : ElectricalTerminalPort :> terminal3;
        attribute polarity : BipolarJunctionPolarity;
        attribute currentGain : Real;
        attribute maximumCollectorEmitterVoltage : ElectricPotentialValue;
        attribute maximumCollectorCurrent : ElectricCurrentValue;
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
