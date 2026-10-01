package RcCircuit {
    doc /*
     * Minimal series RC low-pass circuit: source -> resistor ->
     * capacitor -> ground, source return tied to the same ground.
     * Structural topology only. Dynamic behavior for simulation is a
     * Modelica model or FMU linked from Elan8::PhysicalModeling, with the
     * run declared as a SimulationScenario.
     */

    private import Elan8::Electronics::Components::*;
    private import Elan8::Electronics::Interconnection::*;
    private import SI::*;

    part def RcLowPassCircuit {
        part source : VoltageSource {
            attribute :>> sourceVoltage = 5 [V];
        }

        part resistor : Resistor {
            attribute :>> resistance = 1000 [ohm];
        }

        part capacitor : Capacitor {
            attribute :>> capacitance = 0.000001 [farad];
        }

        part reference : Ground;

        interface sourceToResistor : ElectricalTerminalLink
            connect terminalA ::> source.terminal1
            to terminalB ::> resistor.terminal1;

        interface resistorToCapacitor : ElectricalTerminalLink
            connect terminalA ::> resistor.terminal2
            to terminalB ::> capacitor.terminal1;

        interface capacitorToGround : ElectricalTerminalLink
            connect terminalA ::> capacitor.terminal2
            to terminalB ::> reference.terminal;

        interface sourceReturnToGround : ElectricalTerminalLink
            connect terminalA ::> source.terminal2
            to terminalB ::> reference.terminal;
    }
}
