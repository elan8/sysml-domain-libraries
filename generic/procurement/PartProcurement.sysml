package Elan8 {
    package Procurement {
        enum def PartLifecycleStatus {
            active;
            notRecommendedForNewDesign;
            endOfLife;
            unknown;
        }

        metadata def BuyPart {
            doc /*
              Procurement identity and authoritative external documentation for a
              concrete, purchasable part definition. URLs identify external
              resources; internal model identity remains semantic.
            */
            :> annotatedElement : SysML::PartDefinition;
            attribute manufacturer : String;
            attribute manufacturerPartNumber : String;
            attribute productPageUrl : String;
            attribute datasheetUrl : String;
            attribute datasheetDocumentId : String;
            attribute datasheetRevision : String;
            attribute lifecycleStatus : PartLifecycleStatus;
            attribute sourceCheckedOn : String;
        }
    }
}
