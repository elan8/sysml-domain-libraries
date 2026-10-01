package Sql {
    private import ScalarValues::String;
    private import Elan8::Software::Core::*;
    private import Elan8::Software::Distributed::*;

    attribute def ConsistencyMode;

    part def RelationalStore :> DataStore {
        attribute consistencyMode : ConsistencyMode;
    }

    part def SqlDatabase :> RelationalStore {
        attribute engineName : String;
    }

    part def ReadReplica :> RelationalStore;
}
