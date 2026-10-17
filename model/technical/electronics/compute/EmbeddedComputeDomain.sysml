package Compute {
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Electronics::Power::*;
    private import ISQ::*;

    enum def PeripheralKind {
        gpio;
        pwm;
        adc;
        dac;
        timer;
        uart;
        spi;
        i2c;
        can;
        usb;
        ethernet;
    }

    part def EmbeddedComputeUnit :> ElectronicsComponent {
        doc /*
         * A processor with its memories and peripherals. Software execution
         * platforms (Elan8::Software::ExecutionPlatform) are allocated to it.
         */
        attribute clockFrequency : FrequencyValue[0..1];
        part memories : MemoryBlock[0..*];
        part peripherals : PeripheralBlock[0..*];
        port power : ~PowerRailPort;
    }

    part def Microcontroller :> EmbeddedComputeUnit;
    part def SystemOnChip :> EmbeddedComputeUnit;

    enum def MemoryKind {
        flash;
        ram;
        eeprom;
        rom;
    }

    part def MemoryBlock {
        attribute kind : MemoryKind[0..1];
        attribute capacity : StorageCapacityValue[0..1];
    }

    part def PeripheralBlock {
        attribute kind : PeripheralKind[0..1];
    }
}
