package RequirementMetadata {
    import RequirementManagement::Identifier;
    private import Metaobjects::SemanticMetadata;
    private import Requirements::requirementChecks;

    enum def RequirementRoleKind {
        enum user;
        enum system;
        enum functional;
        enum performance;
        enum safety;
        enum interface;
        enum security;
        enum regulatory;
    }

    metadata def RequirementRole {
        doc /*
          Annotates a requirement usage with its engineering role (user need, system requirement, etc.).
        */
        :> annotatedElement : SysML::RequirementUsage;
        attribute role : RequirementRoleKind;
    }

    metadata def RequirementIdentity {
        doc /* Optional stable identifier for a requirement usage (e.g. USR-001, SYS-042). */
        :> annotatedElement : SysML::RequirementUsage;
        attribute requirementId : Identifier;
    }

    metadata def <user> UserRequirementRole :> SemanticMetadata {
        doc /* Semantic tag for stakeholder/user-facing requirements. */
        :> annotatedElement : SysML::RequirementUsage;
        :>> baseType = requirementChecks meta SysML::Usage;
    }

    metadata def <system> SystemRequirementRole :> SemanticMetadata {
        doc /* Semantic tag for derived system-level requirements. */
        :> annotatedElement : SysML::RequirementUsage;
        :>> baseType = requirementChecks meta SysML::Usage;
    }
}
