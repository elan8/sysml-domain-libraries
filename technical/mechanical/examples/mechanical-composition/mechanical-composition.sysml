/*
 * Minimal composition proving MechanicalCore and the drivetrain additions
 * (Gearbox, Wheel, CasterWheel) reuse cleanly, and demonstrating the
 * sum()-derived mass rollup pattern for a purely mechanical assembly that has
 * no powerDraw (see sysml-robot-vacuum-cleaner's PhysicalArchitecture.sysml
 * BaseModule/DriveTrain for the real-world application of this pattern).
 */
package MechanicalCompositionExample {
    private import DrivetrainDomain::*;
    private import MechanicalCore::*;
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
