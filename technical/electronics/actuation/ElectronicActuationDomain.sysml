package ElectronicActuationDomain {
    private import ElectronicsCore::*;
    private import ElectronicsInterconnection::*;
    private import ISQ::*;

    part def Motor :> ElectronicsComponent {
        attribute ratedPower : PowerValue;
    }

    part def BldcMotor :> Motor {
        port phases : ~ThreePhaseMotorPort;
    }

    part def Encoder :> ElectronicsComponent;

    part def QuadratureEncoder :> Encoder {
        port odometry : QuadratureEncoderPort;
    }

    part def MotorDriver :> ElectronicsComponent {
        port power : PowerRailPort;
        port command : PwmPort;
        port phases : ThreePhaseMotorPort;
        port fault : GpioPort;
    }
}
