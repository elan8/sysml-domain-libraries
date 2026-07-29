package Elan8 {
    package Software {
        package Data {
            package NoSql {
                import Elan8::Software::Distributed::*;

                attribute def DataModelType;

                part def DocumentStore :> DataStore {
                    attribute dataModel : DataModelType;
                }

                part def KeyValueStore :> DataStore {
                    attribute dataModel : DataModelType;
                }

                part def ObjectStore :> DataStore;
            }
        }
    }
}
