package Compute {
    private import Elan8::Core::Name;
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Electronics::Power::*;

    attribute def FirmwareSlot;
    attribute def MemorySizeClass;
    attribute def ComputeClass;
    attribute def PeripheralClass;

    part def EmbeddedComputeUnit :> ElectronicsComponent {
        attribute computeClass : ComputeClass;
        ref memory : MemoryBlock;
        ref peripheral : PeripheralBlock;
        ref powerRail : PowerRail;
        port power : ~PowerRailPort;
    }

    part def Microcontroller :> EmbeddedComputeUnit;
    part def SystemOnChip :> EmbeddedComputeUnit;

    part def MemoryBlock {
        attribute name : Name;
        attribute sizeClass : MemorySizeClass;
    }

    part def PeripheralBlock {
        attribute name : Name;
        attribute peripheralClass : PeripheralClass;
    }
}
