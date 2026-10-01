package BenchInstrumentExample {
    doc /*
     * A small instrument: a made enclosure, a bought microcontroller, and
     * firmware that is not a costed line item. Shows how mechanical,
     * electronics, software, and procurement compose.
     */

    private import Elan8::Mechanical::Core::*;
    private import Elan8::Electronics::Compute::*;
    private import Elan8::Software::Core::*;
    private import Elan8::Procurement::*;
    private import Elan8::Units::Money::*;

    part def InstrumentEnclosure :> MechanicalComponent, CostedPart {
        @MakePart;
        attribute :>> unitCost = 80 [EUR];
    }

    part def InstrumentController :> Microcontroller, CostedPart {
        @BuyPart {
            manufacturer = "Example Semiconductor Co.";
            manufacturerPartNumber = "ES-MCU-100";
            url = "https://example.invalid/es-mcu-100";
        }
        attribute :>> unitCost = 120 [EUR];
    }

    part def InstrumentFirmware :> SoftwareComponent;

    part def BenchInstrument {
        part enclosure : InstrumentEnclosure;
        part controller : InstrumentController;
        part firmware : InstrumentFirmware;
    }
} // package BenchInstrumentExample
