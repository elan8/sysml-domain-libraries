package Pendulum {
    doc /*
     * Point mass on a hinge fixed in the lab. Both releases use
     * m = 0.2 kg, L = 0.5 m, and standard gravity 9.80665 m/s².
     * The 0.01 rad release is the small-angle cosine. The 1 rad
     * release is checked by conservation of mechanical energy.
     * Angular velocity starts at 0, as authored on the Modelica model.
     */

    private import Elan8::Mechanical::Dynamics::*;
    private import Elan8::Mechanical::Interconnection::*;
    private import SI::*;

    part def SmallAnglePendulum {
        part support : InertialFrame;

        part pendulum : Pendulum {
            attribute :>> mass = 0.2 [kg];
            attribute :>> length = 0.5 [m];
            attribute :>> gravity = 9.80665 [m/s**2];
            attribute :>> releaseAngle = 0.01 [rad];
        }

        interface hinge : RotationalMechanicalLink
            connect sideA ::> support.flange
            to sideB ::> pendulum.pivot;
    }

    part def ReleasedPendulum {
        part support : InertialFrame;

        part pendulum : Pendulum {
            attribute :>> mass = 0.2 [kg];
            attribute :>> length = 0.5 [m];
            attribute :>> gravity = 9.80665 [m/s**2];
            attribute :>> releaseAngle = 1 [rad];
        }

        interface hinge : RotationalMechanicalLink
            connect sideA ::> support.flange
            to sideB ::> pendulum.pivot;
    }
}
