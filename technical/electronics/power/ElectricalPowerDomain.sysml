package Elan8 {
    package Electronics {
        package Power {
            import Elan8::Core::*;
            import Elan8::Electronics::Core::*;
            import Elan8::Electronics::Interconnection::*;
            private import ISQ::*;

            attribute def VoltageValue;
            attribute def CurrentValue;
            attribute def PowerClass;
            attribute def EfficiencyClass;

            part def PowerRail :> ElectronicsComponent {
                attribute voltage : VoltageValue;
                attribute currentBudget : CurrentValue;
                attribute powerClass : PowerClass;
                ref suppliedLoad : LoadGroup;
            }

            part def VoltageRegulator :> ElectronicsComponent {
                attribute regulatorName : Name;
                attribute efficiencyClass : EfficiencyClass;
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
                attribute converterName : Name;
                attribute efficiencyClass : EfficiencyClass;
            }

            part def LoadGroup {
                attribute loadName : Name;
                attribute currentBudget : CurrentValue;
                ref suppliedBy : PowerRail;
            }

            part def PowerDistributionNode :> ElectronicsComponent {
                attribute nodeName : Name;
                port railOut0 : PowerRailPort;
                port railOut1 : PowerRailPort;
                port railOut2 : PowerRailPort;
            }

            part def PowerLoadInterface :> ElectricalInterface;
        }
    }
}
