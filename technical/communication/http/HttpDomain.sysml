package Elan8 {
    package Communication {
        package Http {
            import Elan8::Communication::Core::*;

            attribute def HttpEncryptionMode;

            part def HttpEndpoint :> CommunicationEndpoint {
                attribute encryption : HttpEncryptionMode;
            }

            part def RestApiEndpoint :> HttpEndpoint;
            part def HttpRoute :> HttpEndpoint;
            part def HttpService :> CommunicationService;
        }
    }
}
