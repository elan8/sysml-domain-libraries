package EmbeddedComputeDomain {
    import SoftwareCore::*;
    import ElectronicsCore::*;
    import ElectricalPowerDomain::*;

    attribute def FirmwareSlot;
    attribute def MemorySizeClass;
    attribute def ComputeClass;
    attribute def PeripheralClass;

    part def EmbeddedComputeUnit :> ElectronicsComponent {
        attribute unitName : Name;
        attribute computeClass : ComputeClass;
        ref firmwareImage : FirmwareImageSlot;
        ref memory : MemoryBlock;
        ref peripheral : PeripheralBlock;
        ref powerRail : PowerRail;
    }

    part def Microcontroller :> EmbeddedComputeUnit;

    part def SystemOnChip :> EmbeddedComputeUnit;

    part def FirmwareImageSlot {
        attribute slotName : FirmwareSlot;
        attribute version : VersionString;
    }

    part def MemoryBlock {
        attribute memoryName : Name;
        attribute sizeClass : MemorySizeClass;
    }

    part def PeripheralBlock {
        attribute peripheralName : Name;
        attribute peripheralClass : PeripheralClass;
    }
}
