package PhysicalModeling {
    doc /*
     * Domain-agnostic primitives for writing constitutive equations on physical
     * components: a differentiation primitive plus metadata tags distinguishing
     * across (potential) from through (flow) port variables. Physical technical
     * libraries (electrical today; mechanical, thermal, hydraulic later) import
     * this package instead of each inventing an equivalent.
     *
     * `der` has no evaluatable body. A simulation compiler recognizes it by the
     * @DerivativePrimitive tag and substitutes a state derivative during DAE
     * assembly; Spec42 only needs to resolve it as an ordinary calculation.
     *
     * @AcrossVariable / @ThroughVariable label which port attributes are
     * potential-like versus flow-like. Apply them inline on the attribute usage
     * (see Elan8::Electronics::Interconnection::ElectricalTerminalPort). They do
     * not, by themselves, make a plain `connect`/`interface` equalize across
     * variables or sum through variables to zero at a shared node -- SysML
     * feature binding equates all matching features, which is correct for across
     * variables but wrong for through variables (KCL-style conservation needs
     * signed summation across every connection at a node). Deriving conservation
     * constraints from connection topology is the simulation compiler's job, not
     * this library's.
     *
     * Acausal `constraint` bodies use `==` (the KerML/SysML equality operator);
     * `=` is a feature-value binding and is a syntax error in a constraint body.
     */

    private import ScalarValues::*;

    metadata def DerivativePrimitive {
        doc /* Marks a calculation the simulation compiler replaces with a state derivative. */
    }
    metadata def AcrossVariable {
        doc /* Marks a port attribute as potential-like: connected ends are set equal. */
    }
    metadata def ThroughVariable {
        doc /* Marks a port attribute as flow-like: connected ends sum to zero at a node. */
    }

    calc def der {
        @DerivativePrimitive;
        in x : Real[1];
        return : Real[1];
    }
}
