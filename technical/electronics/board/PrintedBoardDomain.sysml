package PrintedBoardDomain {
    private import Core::*;
    private import ISQ::*;
    private import ScalarValues::*;

    enum def PrintedBoardTechnology {
        rigid;
        flexible;
        rigidFlex;
    }

    attribute def LayerCount :> Natural;
    attribute def BoardMaterial :> String;

    part def PrintedCircuitBoard :> PhysicalComponent {
        attribute layerCount : LayerCount;
        attribute technology : PrintedBoardTechnology;
        attribute material : BoardMaterial;
        attribute thickness : LengthValue;
        attribute width : LengthValue;
        attribute height : LengthValue;
    }
}
