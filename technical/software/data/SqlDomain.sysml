package Elan8 {
    package Software {
        package Data {
            package Sql {
                private import Elan8::Core::Name;
                import Elan8::Software::Core::*;
                import Elan8::Software::Distributed::*;

                attribute def ConsistencyMode;

                part def RelationalStore :> DataStore {
                    attribute consistencyMode : ConsistencyMode;
                }

                part def SqlDatabase :> RelationalStore {
                    attribute engineName : Name;
                }

                part def ReadReplica :> RelationalStore;
            }
        }
    }
}
