package Elan8 {
    package Core {
        private import ISQ::*;
        attribute def Identifier;
        attribute def Name;

        part def PhysicalComponent  {
            attribute name : Name;
            attribute mass : MassValue;
        }
    }
}
