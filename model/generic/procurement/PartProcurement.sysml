package Procurement {
    private import ScalarValues::*;
    private import Elan8::Units::Money::*;

    doc
    /* How a concrete part definition is obtained. A part is either a buy part
     * (catalog hardware) or a make part (designed for the system). Unit cost
     * is a purchase-price estimate on a buy part and a manufacturing-cost
     * estimate on a make part. It is not a supplier quote. The amount carries
     * a MonetaryUnit, for example 120 [EUR]. Roll-ups assume one currency.
     *
     * The amount is an attribute of CostedPart. Make versus buy is metadata,
     * and those values are literals (names and URLs).
     */

    enum def PartLifecycleStatus {
        active;
        notRecommendedForNewDesign;
        endOfLife;
        unknown;
    }

    abstract part def CostedPart {
        doc
        /* A part that has a unit cost. Specialize this from a hardware or
         * software part definition and set unitCost on the part.
         */
        attribute unitCost : MonetaryAmount [0..1];
    }

    metadata def BuyPart {
        doc
        /* Commercial off-the-shelf part. Supplier and manufacturer part number
         * may be left unset until a source is selected. URLs identify external
         * resources; internal model identity remains semantic.
         */
        :> annotatedElement : SysML::PartDefinition;
        attribute manufacturer : String;
        attribute manufacturerPartNumber : String;
        attribute url : String;
    }

    metadata def MakePart {
        doc
        /* Part designed and manufactured for the system, not purchased as a
         * catalog item.
         */
        :> annotatedElement : SysML::PartDefinition;
    }
} // package Procurement
