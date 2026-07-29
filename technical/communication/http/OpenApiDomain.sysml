package Elan8 {
    package Communication {
        package OpenApi {
            private import Elan8::Core::Name;
            private import Elan8::Core::Identifier;
            private import Elan8::Communication::Core::UriString;
            import Elan8::Software::Core::*;
            import Elan8::Communication::Http::*;
            import Elan8::Communication::Serialization::*;

            attribute def SpecificationVersion;

            part def OpenApiSpecification {
                attribute specificationName : Name;
                attribute specificationVersion : SpecificationVersion;
                attribute specificationUri : UriString;
            }

            part def OpenApiOperation :> RestApiEndpoint {
                attribute operationId : Identifier;
            }

            item def OpenApiSchema :> JsonPayload;
        }
    }
}
