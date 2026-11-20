package MassSpringDamper {
    doc /*
     * A 1 kg mass on a 100 N/m spring and a 4 N·s/m damper, both fixed to a wall. The mass is
     * pulled 0.1 m out and released at rest. The natural frequency is ω₀ = √(k/m) = 10 rad/s
     * and the damping ratio is ζ = c / (2√(km)) = 0.2, so the mass position follows
     *   x(t) = 0.1 m · e^(−2t) · (cos ω_d t + (2/ω_d) sin ω_d t),  ω_d = √96 rad/s.
     *
     * The model is plain SysML: each part binds to a Modelica Standard Library class through
     * the library, so a simulation tool needs no Modelica of its own. `:=` gives the initial
     * value of a state; `=` gives a parameter.
     */

    private import Elan8::Mechanical::Translational::*;
    private import SI::*;

    part def Oscillator {
        part wall : FixedSupport {
            attribute :>> position = 0 [m];
        }
        part spring : Spring {
            attribute :>> stiffness = 100 [N / m];
            attribute :>> unstretchedLength = 0 [m];
        }
        part damper : Damper {
            attribute :>> damping = 4 [N * s / m];
        }
        part body : Mass {
            attribute :>> mass = 1 [kg];
            attribute :>> position := 0.1 [m];
            attribute :>> velocity := 0 [m / s];
        }

        connect wall.side to spring.sideA;
        connect spring.sideB to body.sideA;
        connect wall.side to damper.sideA;
        connect damper.sideB to body.sideA;
    }
}
