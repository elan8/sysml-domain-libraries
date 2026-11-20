package DriveWheel {
    doc /*
     * A battery-powered drive: a 12 V supply drives a brushed DC motor, which turns a wheel
     * through a 10:1 gearbox; the wheel rolls a 1 kg body along. The motor has a 2 Ω armature,
     * 5 mH, a 0.05 N·m/A torque constant and a 1e-4 kg·m² rotor.
     *
     * Seen from the motor shaft the body is an inertia of M·(r / n)² = 9e-6 kg·m², so the motor
     * drives a second-order linear system: the shaft settles at V / k = 240 rad/s, and the body
     * at 0.003 times that, 0.72 m/s.
     *
     * The model is plain SysML. A simulation tool takes each part's physics from the library.
     */

    private import Elan8::Electronics::Components::*;
    private import Elan8::Electronics::Actuation::*;
    private import Elan8::Mechanical::Drivetrain::*;
    private import Elan8::Mechanical::Translational::*;
    private import MeasurementReferences::one;
    private import SI::*;

    part def Drive {
        part supply : VoltageSource {
            attribute :>> sourceVoltage = 12 [V];
        }
        part ground : Ground;
        part motor : BrushedDcMotor {
            attribute :>> armatureResistance = 2 [ohm];
            attribute :>> armatureInductance = 5 [milli * H];
            attribute :>> torqueConstant = 0.05 [N * m / A];
            attribute :>> rotorInertia = 1e-4 [kg * m * m];
        }
        part gearbox : Gearbox {
            attribute :>> gearRatio = 10 [one];
        }
        part wheel : RollingWheel {
            attribute :>> radius = 30 [mm];
        }
        part body : Mass {
            attribute :>> mass = 1 [kg];
        }

        connect supply.terminal1 to motor.terminal1;
        connect motor.terminal2 to ground.terminal;
        connect supply.terminal2 to ground.terminal;
        connect motor.mechanicalOutput to gearbox.rotationalInput;
        connect gearbox.rotationalOutput to wheel.axle;
        connect wheel.contact to body.sideA;
    }
}
