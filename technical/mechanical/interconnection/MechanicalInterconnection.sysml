package Elan8 {
    package Mechanical {
        package Interconnection {
            private import ISQ::*;

            port def MechanicalPort;

            port def RotationalMechanicalPort :> MechanicalPort {
                attribute angle : AngularMeasureValue;
                attribute angularVelocity : AngularVelocityValue;
                attribute torque : TorqueValue;
            }

            port def TranslationalMechanicalPort :> MechanicalPort {
                attribute position : LengthValue;
                attribute velocity : SpeedValue;
                attribute force : ForceValue;
            }

            interface def RotationalMechanicalLink {
                end sideA : RotationalMechanicalPort;
                end sideB : RotationalMechanicalPort;
            }

            interface def TranslationalMechanicalLink {
                end sideA : TranslationalMechanicalPort;
                end sideB : TranslationalMechanicalPort;
            }
        }
    }
}
