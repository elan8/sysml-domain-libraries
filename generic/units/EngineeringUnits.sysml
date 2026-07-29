package Elan8 {
    package Units {
        package Engineering {
          doc /*
            Generic engineering unit literals commonly needed beyond the OMG SI base
            set: ampere-hour charge and millisecond duration. Domain-agnostic.
          */

          private import MeasurementReferences::*;
          private import ISQ::*;
          private import SI::*;
          private import SIPrefixes::*;

          attribute <Ah> 'ampere hour' : ElectricChargeUnit = A*h;

          attribute <mAh> 'milliampere hour' : ElectricChargeUnit {
            :>> unitConversion {
              private attribute prefix : UnitPrefix = milli;
              :>> referenceUnit = Ah;
              :>> conversionFactor = prefix.conversionFactor;
            }
          }

          attribute <ms> millisecond : DurationUnit {
            :>> unitConversion {
              private attribute prefix : UnitPrefix = milli;
              :>> referenceUnit = s;
              :>> conversionFactor = prefix.conversionFactor;
            }
          }
        }
    }
}
