package Elan8 {
    package Electronics {
        package Compute {
            import Elan8::Core::Name;
            import Elan8::Electronics::Core::*;
            import Elan8::Electronics::Interconnection::*;
            import Elan8::Electronics::Power::*;

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
    }
}
