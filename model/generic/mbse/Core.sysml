package Core {
    doc /*
     * Cross-domain foundation. An element's name is its SysML declared name;
     * definitions carry no separate name attribute.
     */
    private import ISQ::*;

    part def PhysicalComponent {
        doc /* A component with physical extent, so it has a mass. */
        attribute mass : MassValue;
    }
} // package Core
