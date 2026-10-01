package PartSourcingExample {
    private import Elan8::Procurement::*;
    private import Elan8::Units::Money::*;

    part def CatalogMcu :> CostedPart {
        @BuyPart {
            manufacturer = "Example Semiconductor Co.";
            manufacturerPartNumber = "ES-MCU-100";
            url = "https://example.invalid/es-mcu-100";
        }
        attribute :>> unitCost = 120 [EUR];
    }

    part def MachinedBracket :> CostedPart {
        @MakePart;
        attribute :>> unitCost = 45 [EUR];
    }
} // package PartSourcingExample
