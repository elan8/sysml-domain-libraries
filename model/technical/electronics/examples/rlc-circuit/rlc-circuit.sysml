package RlcCircuit {
    doc /*
     * Series RLC step response: source -> resistor -> inductor ->
     * capacitor -> ground, source return tied to the same ground.
     * V = 5 V, R = 100 ohm, L = 10 mH, C = 1 µF, so the circuit is
     * underdamped (α = R/(2L) = 5000 s⁻¹, ω₀ = 1/√(LC) = 10000 rad/s).
     * Capacitor voltage starts at 0 and inductor current starts at 0,
     * the initial state authored on those Modelica models.
     * Structural topology only. Dynamic behavior for simulation is the
     * Modelica model linked from Elan8::PhysicalModeling.
     */

    private import Elan8::Electronics::Components::*;
    private import Elan8::Electronics::Interconnection::*;
    private import SI::*;

    part def RlcSeriesCircuit {
        part source : VoltageSource {
            attribute :>> sourceVoltage = 5 [V];
        }

        part resistor : Resistor {
            attribute :>> resistance = 100 [ohm];
        }

        part inductor : Inductor {
            attribute :>> inductance = 0.01 [henry];
        }

        part capacitor : Capacitor {
            attribute :>> capacitance = 0.000001 [farad];
        }

        part reference : Ground;

        interface sourceToResistor : ElectricalTerminalLink
            connect terminalA ::> source.terminal1
            to terminalB ::> resistor.terminal1;

        interface resistorToInductor : ElectricalTerminalLink
            connect terminalA ::> resistor.terminal2
            to terminalB ::> inductor.terminal1;

        interface inductorToCapacitor : ElectricalTerminalLink
            connect terminalA ::> inductor.terminal2
            to terminalB ::> capacitor.terminal1;

        interface capacitorToGround : ElectricalTerminalLink
            connect terminalA ::> capacitor.terminal2
            to terminalB ::> reference.terminal;

        interface sourceReturnToGround : ElectricalTerminalLink
            connect terminalA ::> source.terminal2
            to terminalB ::> reference.terminal;
    }
}
