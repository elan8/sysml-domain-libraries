package SystemsEngineering {
    doc /*
     * Engineering roles for recursive system development, exported as
     * Elan8::SystemsEngineering. Roles classify intent; project definitions
     * must also specialize their actual system contract or selected architecture.
     * Type conformance does not establish verified engineering compliance.
     */

    view def ContextView :> StandardViewDefinitions::GeneralView {
        doc /* Expose the context package: system and external participant usages,
             * their ports and connections. Referenced participants stay external. */
        filter @SysML::PartUsage or @SysML::PortUsage or @SysML::ConnectionUsage
            or @SysML::BindingConnectorAsUsage or @SysML::FlowUsage;
        filter not @SysML::ViewUsage;
    }

    view def SpecificationView :> StandardViewDefinitions::GeneralView {
        doc /* Expose a specification package: boundary definition, features,
             * requirements and constraints. Expressions remain in the model. */
        filter @SysML::Definition or @SysML::Usage;
        filter not @SysML::ViewUsage;
    }

    view def ArchitectureView :> StandardViewDefinitions::GeneralView {
        doc /* Expose an architecture definition: constituent contract usages,
             * ports and topology. Behavior can use a separate standard view. */
        filter @SysML::PartDefinition or @SysML::PartUsage
            or @SysML::PortUsage or @SysML::ConnectionUsage
            or @SysML::BindingConnectorAsUsage or @SysML::FlowUsage;
        filter not @SysML::ViewUsage;
    }

    view def IntegrationView :> StandardViewDefinitions::GeneralView {
        doc /* Expose a selected integration usage: effective constituent designs,
             * ports and topology. This view is not a compatibility assessment. */
        filter @SysML::PartUsage or @SysML::PortUsage or @SysML::ConnectionUsage
            or @SysML::BindingConnectorAsUsage or @SysML::FlowUsage;
        filter not @SysML::ViewUsage;
    }

    abstract part def SystemSpecification {
        doc /* Boundary contract: observable behavior, interfaces, properties,
             * assumptions and obligations. Internal constituent-system
             * decomposition belongs in an architecture. */
    }

    abstract part def SystemArchitecture :> SystemSpecification {
        doc /* Proposed realization of a system contract. A project architecture
             * also specializes its own SystemSpecification and introduces child
             * usages typed by subsystem specifications, responsibilities and
             * interactions. The inherited role does not prohibit decomposition. */
    }

    abstract part def SystemIntegration :> SystemArchitecture {
        doc /* Selected configuration. A project integration also specializes its
             * selected architecture and redefines inherited child usages with
             * compatible designs. Reconcile parent-local obligations explicitly;
             * selection and inheritance are not verification evidence. */
    }
}
