package Power {
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import ISQ::*;
    private import MeasurementReferences::DimensionOneValue;

    part def PowerRail :> ElectronicsComponent {
        doc /* A supply rail with its nominal voltage and the current it can deliver. */
        attribute voltage : ElectricPotentialValue;
        attribute currentBudget : ElectricCurrentValue[0..1];
        ref suppliedLoad : LoadGroup[0..*];
    }

    part def VoltageRegulator :> ElectronicsComponent {
        attribute efficiency : DimensionOneValue[0..1] {
            doc /* Output power over input power, between 0 and 1. */
        }
        attribute outputVoltage : ElectricPotentialValue;
        attribute quiescentPower : PowerValue;
        ref inputRail : PowerRail;
        ref outputRail : PowerRail;
        port input : PowerRailPort;
        port output : PowerRailPort;
    }

    part def BatteryPack :> ElectronicsComponent {
        attribute nominalCapacity : ElectricChargeValue;
        attribute nominalVoltage : ElectricPotentialValue;
        doc /* Rechargeable pack with one bidirectional DC terminal boundary. */
        port terminal : DcPowerPort;
    }

    part def BatteryCharger :> ElectronicsComponent {
        attribute maxChargeCurrent : ElectricCurrentValue;
        attribute quiescentPower : PowerValue;
        port supplyInput : ~PowerRailPort;
        port chargeOutput : DcPowerPort;
    }

    part def BatteryManagementSystem :> ElectronicsComponent {
        attribute maxChargeCurrent : ElectricCurrentValue;
        attribute maxCellTemperature : ThermodynamicTemperatureValue;
        attribute quiescentPower : PowerValue;
        doc /*
         * Protects and monitors the pack for charging and discharging.
         * Charging energy enters at chargeInput; protectedOutput supplies
         * the system loads; batteryTerminal connects to the cell pack.
         */
        port batteryTerminal : DcPowerPort;
        port chargeInput : ~DcPowerPort;
        port protectedOutput : PowerRailPort;
        port bus : I2cTargetPort;
        port alert : GpioPort;
    }

    part def DcDcConverter :> ElectronicsComponent {
        attribute efficiency : DimensionOneValue[0..1] {
            doc /* Output power over input power, between 0 and 1. */
        }
        port input : DcPowerPort;
        port output : DcPowerPort;
    }

    part def LoadGroup {
        attribute currentBudget : ElectricCurrentValue[0..1];
        ref suppliedBy : PowerRail;
    }

    part def PowerDistributionNode :> ElectronicsComponent {
        port railOut0 : PowerRailPort;
        port railOut1 : PowerRailPort;
        port railOut2 : PowerRailPort;
    }

    part def PowerLoadInterface :> ElectricalInterface;
}
