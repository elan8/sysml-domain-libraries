package Elan8 {
    package Examples {
        package Electronics {
            package MotorAndPowerModule {
                private import Elan8::Electronics::Actuation::*;
                private import Elan8::Electronics::Power::*;
                private import Elan8::Electronics::Core::*;
                private import Elan8::Units::Engineering::*;
                private import ISQ::*;
                private import SI::*;

                part def SampleActuationModule :> ElectronicsComponent {
                    part motor : BldcMotor {
                        attribute :>> ratedPower = 14 [W];
                        attribute :>> mass = 0.5 [kg];
                    }
                    part driver : ThreePhaseMotorDriver {
                        attribute :>> mass = 0.05 [kg];
                    }
                    attribute :>> mass = sum(motor.mass, driver.mass);
                    attribute :>> powerDraw = sum(motor.ratedPower);
                }

                part def SampleAuxiliaryActuators :> ElectronicsComponent {
                    part stepper : StepperMotor {
                        attribute :>> ratedPower = 8 [W];
                        attribute :>> mass = 0.3 [kg];
                    }
                    part stepperDriver : StepperMotorDriver {
                        attribute :>> mass = 0.04 [kg];
                    }
                    part solenoid : DcSolenoid {
                        attribute :>> ratedPower = 6 [W];
                        attribute :>> mass = 0.2 [kg];
                    }
                    part solenoidDriver : SolenoidDriver {
                        attribute :>> mass = 0.03 [kg];
                    }
                    part servo : PwmRotationalServoActuator {
                        attribute :>> ratedPower = 5 [W];
                        attribute :>> mass = 0.15 [kg];
                    }
                    attribute :>> mass = sum(
                        stepper.mass,
                        stepperDriver.mass,
                        solenoid.mass,
                        solenoidDriver.mass,
                        servo.mass
                    );
                    attribute :>> powerDraw = sum(
                        stepper.ratedPower,
                        solenoid.ratedPower,
                        servo.ratedPower
                    );
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
        }
    }
}
