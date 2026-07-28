/*
 * Minimal composition proving ElectronicActuationDomain and the ElectricalPowerDomain
 * additions (BatteryPack, BatteryManagementSystem, upgraded VoltageRegulator) reuse
 * cleanly, and demonstrating the sum()-derived mass/power rollup pattern that replaces
 * hand-typed totals (see sysml-robot-vacuum-cleaner's PhysicalArchitecture.sysml for
 * the real-world application of this pattern).
 */
package MotorAndPowerModuleExample {
    private import ElectronicActuationDomain::*;
    private import ElectricalPowerDomain::*;
    private import ElectronicsCore::*;
    private import EngineeringUnits::*;
    private import ISQ::*;
    private import SI::*;

    part def SampleActuationModule :> ElectronicsComponent {
        part motor : BldcMotor {
            attribute :>> ratedPower = 14 [W];
            attribute :>> mass = 0.5 [kg];
        }
        part encoder : QuadratureEncoder {
            attribute :>> mass = 0.1 [kg];
        }
        part driver : MotorDriver {
            attribute :>> mass = 0.05 [kg];
        }
        attribute :>> mass = sum(motor.mass, encoder.mass, driver.mass);
        attribute :>> powerDraw = sum(motor.ratedPower);
    }

    part def SamplePowerModule :> ElectronicsComponent {
        part battery : BatteryPack {
            attribute :>> nominalCapacity = 12500 [mAh];
            attribute :>> nominalVoltage = 14.4 [V];
            attribute :>> mass = 0.4 [kg];
        }
        part bms : BatteryManagementSystem {
            attribute :>> maxChargeCurrent = 2 [A];
            attribute :>> maxCellTemperature = 328.15 [K];
            attribute :>> quiescentPower = 1 [W];
            attribute :>> mass = 0.05 [kg];
        }
        part regulator : VoltageRegulator {
            attribute :>> outputVoltage = 5 [V];
            attribute :>> quiescentPower = 0.5 [W];
            attribute :>> mass = 0.02 [kg];
        }
        attribute :>> mass = sum(battery.mass, bms.mass, regulator.mass);
        attribute :>> powerDraw = sum(bms.quiescentPower, regulator.quiescentPower);
    }
}
