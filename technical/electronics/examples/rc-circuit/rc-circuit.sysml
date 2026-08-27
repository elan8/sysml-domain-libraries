package Elan8 {
    package Examples {
        package Electronics {
            package RcCircuit {
                doc /*
                 * Minimal series RC low-pass circuit: source -> resistor ->
                 * capacitor -> ground, source return tied to the same ground.
                 * Demonstrates the constitutive equations added to Resistor,
                 * Capacitor, and VoltageSource (see
                 * Elan8::Electronics::Components::ElectronicComponentDomain) wired
                 * into a simulatable topology. See the known Spec42 gap noted in
                 * Elan8::PhysicalModeling before expecting these constraints to show
                 * up in Spec42's semantic graph today.
                 */

                private import Elan8::Electronics::Components::*;
                private import Elan8::Electronics::Interconnection::*;
                private import SI::*;

                part def RcLowPassCircuit {
                    part source : VoltageSource {
                        attribute :>> sourceVoltage = 5 [V];
                    }

                    part resistor : Resistor {
                        attribute :>> resistance = 1000;
                    }

                    part capacitor : Capacitor {
                        attribute :>> capacitance = 0.000001;
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
        }
    }
}
