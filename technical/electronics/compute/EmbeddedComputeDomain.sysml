package EmbeddedComputeDomain {
    import Core::Name;
    import ElectronicsCore::*;
    import ElectricalPowerDomain::*;

    attribute def FirmwareSlot;
    attribute def MemorySizeClass;
    attribute def ComputeClass;
    attribute def PeripheralClass;

    part def EmbeddedComputeUnit :> ElectronicsComponent {
        attribute computeClass : ComputeClass;
        ref memory : MemoryBlock;
        ref peripheral : PeripheralBlock;
        ref powerRail : PowerRail;
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
