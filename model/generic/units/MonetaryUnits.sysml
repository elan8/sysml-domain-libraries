package Money {
    private import ScalarValues::*;
    private import Quantities::*;
    private import MeasurementReferences::*;

    doc /*
     * Currency quantity for BOM and cost analyses. The short name of each
     * unit is the ISO 4217 alphabetic code, used in unit literals such as
     * 120 [EUR]. `symbol` is the typographic sign. `decimalPlaces` is the
     * ISO 4217 minor-unit exponent. Roll-ups assume one currency per expression.
     */

    attribute def MonetaryAmount :> ScalarQuantityValue {
        attribute :>> num : Real;
        attribute :>> mRef : MonetaryUnit[1];
    }

    attribute monetaryAmounts : MonetaryAmount[*] nonunique :> scalarQuantities;

    attribute currencyQuantities : SystemOfQuantities {
        attribute :>> baseQuantities = (currency);
        attribute currency : MonetaryAmount[1];
    }

    attribute def MonetaryUnit :> SimpleUnit {
        attribute symbol : String;
        attribute decimalPlaces : Integer;
        private attribute currencyPF : QuantityPowerFactor[1] {
            :>> quantity = currencyQuantities.currency;
            :>> exponent = 1;
        }
        attribute :>> quantityDimension {
            :>> quantityPowerFactors = currencyPF;
        }
    }

    attribute <EUR> 'euro' : MonetaryUnit {
        :>> symbol = "€";
        :>> decimalPlaces = 2;
    }
    attribute <USD> 'US dollar' : MonetaryUnit {
        :>> symbol = "$";
        :>> decimalPlaces = 2;
    }
    attribute <GBP> 'pound sterling' : MonetaryUnit {
        :>> symbol = "£";
        :>> decimalPlaces = 2;
    }
    attribute <JPY> 'yen' : MonetaryUnit {
        :>> symbol = "¥";
        :>> decimalPlaces = 0;
    }
    attribute <CHF> 'Swiss franc' : MonetaryUnit {
        :>> symbol = "Fr.";
        :>> decimalPlaces = 2;
    }
    attribute <CNY> 'yuan' : MonetaryUnit {
        :>> symbol = "¥";
        :>> decimalPlaces = 2;
    }
}
