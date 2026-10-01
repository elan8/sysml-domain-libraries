package NoSql {
    private import Elan8::Software::Distributed::*;

    attribute def DataModelType;

    part def DocumentStore :> DataStore {
        attribute dataModel : DataModelType;
    }

    part def KeyValueStore :> DataStore {
        attribute dataModel : DataModelType;
    }

    part def ObjectStore :> DataStore;
}
