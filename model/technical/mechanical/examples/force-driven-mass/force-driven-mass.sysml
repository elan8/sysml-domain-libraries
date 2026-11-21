package ForceDrivenMass {
    private import Elan8::Mechanical::Translational::*;
    private import ISQ::*;
    private import SI::*;

    part def Experiment {
        part bias : ConstantForceSource {
            attribute :>> force = 2 [N];
        }
        part drive : StepForceSource {
            attribute :>> initialForce = 0 [N];
            attribute :>> stepHeight = 4 [N];
            attribute :>> stepTime = 0.25 [s];
        }
        part body : Mass {
            attribute :>> mass = 2 [kg];
            attribute :>> position := 0 [m];
            attribute :>> velocity := 0 [m/s];
        }
        part positionSensor : LinearPositionSensor;

        connect bias.side to body.sideA;
        connect drive.side to body.sideA;
        connect body.sideB to positionSensor.side;

        attribute measuredPosition : LengthValue;
        bind measuredPosition = positionSensor.s;
    }

    part def CommandedExperiment {
        part drive : SignalForceSource;
        part body : Mass {
            attribute :>> mass = 2 [kg];
            attribute :>> position := 0 [m];
            attribute :>> velocity := 0 [m/s];
        }
        part positionSensor : LinearPositionSensor;
        part speedSensor : LinearSpeedSensor;
        part accelerationSensor : LinearAccelerationSensor;

        connect drive.side to body.sideA;
        connect body.sideB to positionSensor.side;
        connect body.sideB to speedSensor.side;
        connect body.sideB to accelerationSensor.side;
    }
}
