package StandardElectronicComponentsExample {
    private import ElectronicComponentDomain::*;
    private import ElectronicsInterconnection::*;
    private import SI::*;

    part def StatusLedCircuit {
        part currentLimitingResistor : Resistor {
            attribute :>> resistance = 330;
            attribute :>> ratedPower = 0.25 [W];
        }

        part statusLed : LightEmittingDiode {
            attribute :>> forwardVoltage = 2.1 [V];
        }

        interface : ElectricalTerminalLink
            connect terminalA ::> currentLimitingResistor.terminal2
            to terminalB ::> statusLed.anode;
    }
}
