package MonetaryUnits {
  private import ScalarValues::Real;

  /**
   * Scalar quantity typed for BOM and cost analyses.
   * Values must carry a currency unit (e.g. 120 [EUR]).
   * Roll-ups assume a single currency per expression.
   */
  attribute def MonetaryAmount :> Real;

  attribute def MonetaryUnit;

  attribute <EUR> 'euro' : MonetaryUnit;
  attribute <USD> 'US dollar' : MonetaryUnit;
  attribute <GBP> 'pound sterling' : MonetaryUnit;
  attribute <JPY> 'yen' : MonetaryUnit;
  attribute <CHF> 'Swiss franc' : MonetaryUnit;
  attribute <CNY> 'yuan' : MonetaryUnit;
}
