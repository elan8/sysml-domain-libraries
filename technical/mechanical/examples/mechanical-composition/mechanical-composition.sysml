package Elan8 {
    package Examples {
        package Mechanical {
            package Composition {
                private import Elan8::Mechanical::Drivetrain::*;
                private import Elan8::Mechanical::Core::*;
                private import ISQ::*;
                private import SI::*;

                part def SampleDriveTrainAssembly :> MechanicalComponent {
                    part gearbox : Gearbox {
                        attribute :>> gearRatio = 30;
                        attribute :>> mass = 0.15 [kg];
                    }
                    part wheel : Wheel {
                        attribute :>> diameter = 65 [mm];
                        attribute :>> mass = 0.08 [kg];
                    }
                    part caster : CasterWheel {
                        attribute :>> mass = 0.03 [kg];
                    }
                    attribute :>> mass = sum(gearbox.mass, wheel.mass, caster.mass);
                }
            }
        }
    }
}
