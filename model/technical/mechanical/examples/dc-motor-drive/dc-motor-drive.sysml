package DcMotorDrive {
    private import Elan8::Electronics::Actuation::BrushedDcMotor;
    private import Elan8::Electronics::Components::*;
    private import Elan8::Mechanical::Rotational::*;
    private import ISQ::*;
    private import SI::*;

    enum def VerificationMethodKind { test; }
    metadata def VerificationMethod { attribute kind : VerificationMethodKind; }

    part def Drive {
        part supply : StepVoltageSource {
            attribute :>> initialVoltage = 0 [V];
            attribute :>> stepHeight = 12 [V];
            attribute :>> stepTime = 100 [milli * s];
        }
        part ammeter : CurrentSensor;
        part ground : Ground;
        part motor : BrushedDcMotor {
            attribute :>> armatureResistance = 2 [ohm];
            attribute :>> armatureInductance = 100 [milli * H];
            attribute :>> torqueConstant = 0.1 [N * m / A];
            attribute :>> rotorInertia = 0.002 [kg * m * m];
        }
        part load : Inertia {
            attribute :>> inertia = 0.008 [kg * m * m];
            attribute :>> angle := 0 [rad];
            attribute :>> angularVelocity := 0 [rad / s];
        }
        part damper : TorsionalDamper {
            attribute :>> damping = 0.1 [N * m * s / rad];
        }
        part housing : RotationalFixedSupport {
            attribute :>> angle = 0 [rad];
        }
        part tachometer : ShaftSpeedSensor;

        connect supply.terminal1 to ammeter.terminal1;
        connect ammeter.terminal2 to motor.terminal1;
        connect motor.terminal2 to ground.terminal;
        connect supply.terminal2 to ground.terminal;
        connect motor.mechanicalOutput to load.sideA;
        connect load.sideB to damper.sideA;
        connect load.sideB to tachometer.shaft;
        connect damper.sideB to housing.side;

        attribute armatureCurrent : ElectricCurrentValue;
        attribute shaftSpeed : AngularVelocityValue;
        bind armatureCurrent = ammeter.i;
        bind shaftSpeed = tachometer.w;
    }

    requirement reachesOperatingSpeed {
        doc /* At 1 s the shaft speed shall be between 5.70 and 5.73 rad/s, inclusive. */
    }

    verification operatingSpeedTest {
        @VerificationMethod { kind = VerificationMethodKind::test; }
        subject drive : Drive;
        objective { verify reachesOperatingSpeed; }
        action waitForDrive { accept after 1 [s]; }
        assert constraint {
            drive.shaftSpeed >= 5.70 [rad/s] and drive.shaftSpeed <= 5.73 [rad/s]
        }
    }
}
