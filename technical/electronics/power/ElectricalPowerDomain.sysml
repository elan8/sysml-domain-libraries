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
                port output : PowerRailPort;
            }

            part def BatteryManagementSystem :> ElectronicsComponent {
                attribute maxChargeCurrent : ElectricCurrentValue;
                attribute maxCellTemperature : ThermodynamicTemperatureValue;
                attribute quiescentPower : PowerValue;
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
