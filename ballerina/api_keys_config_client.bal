import ballerina/http;
import ballerina.graphql;

# Provides API key configurations needed when communicating with a remote HTTP endpoint.
public type ApiKeysConfig record {|
   # Represents API Key `X-Access-Token`
   string xAccessToken;
|};

public isolated client class ApiKeysConfigClient {
    final graphql:Client graphqlClient;
    final readonly & ApiKeysConfig apiKeyConfig;

    # Gets invoked to initialize the `connector`.
    #
    # + apiKeyConfig - API keys for authorization 
    # + serviceUrl - URL of the target service
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + return - An error at the failure of client initialization
    public isolated function init(ApiKeysConfig apiKeyConfig, string serviceUrl, 
                                  http:ClientConfiguration clientConfig = {}) 
                                  returns graphql:Error? {
        graphql:Client clientEp = check new (serviceUrl, clientConfig);
        self.graphqlClient = clientEp; 
        self.apiKeyConfig = apiKeyConfig.cloneReadOnly();
        return;
    }

    remote isolated function countryByCode(string code) returns CountryByCodeResponse|graphql:Error {
        string query = string `query CountryByCode($code: ID!) {
            country(code: $code) {
                name
            }
        }`; 

        map<anydata> variables = {"code": code};

        map<any> headerValues = {"Access-Token": self.apiKeyConfig.xAccessToken};          
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);

        return <CountryByCodeResponse> check self.graphqlClient->execute(CountryByCodeResponse, query, variables, httpHeaders);
    }

    remote isolated function countriesWithContinent(CountryFilterInput? filter = ())
                                                    returns CountriesWithContinentResponse|graphql:Error {
        string query =
        string `query CountriesWithContinent($filter: CountryFilterInput) { 
           countries(filter: $filter) {   
               name
               continent {
                   countries {
                       name
                   }
               }
           }
       }`;

        map<anydata> variables = {"filter": filter};

        map<any> headerValues = {"Access-Token": self.apiKeyConfig.xAccessToken};          
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);

        return <CountriesWithContinentResponse> check self.graphqlClient->execute(CountriesWithContinentResponse, query, variables, httpHeaders);
    }

    remote isolated function countryAndCountries(string code, CountryFilterInput? filter = ())
                                                returns CountryAndCountriesResponse|graphql:Error {
        string query =
        string `query CountryAndCountries($code: ID!, $filter: CountryFilterInput) { 
           country(code: $code) {
               name
           }
           countries(filter: $filter) {   
               name
               continent {
                   countries {
                       continent {
                           name
                       }
                   }
               }
           }
       }`;

        map<anydata> variables = {"code": code, "filter": filter};

        map<any> headerValues = {"Access-Token": self.apiKeyConfig.xAccessToken};          
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);

        return <CountryAndCountriesResponse> check self.graphqlClient->execute(CountryAndCountriesResponse, query, variables, httpHeaders);
    }

    remote isolated function neighbouringCountries() returns NeighbouringCountriesResponse|graphql:Error {
        string query =
            string `query NeighbouringCountries { 
            countries(filter: {code: {eq: "LK"}}) {   
                name
                continent {
                    countries {
                        name
                    }
                }
            }
        }`;

        map<anydata> variables = {};

        map<any> headerValues = {"Access-Token": self.apiKeyConfig.xAccessToken};          
        map<string|string[]> httpHeaders = getMapForHeaders(headerValues);

        return <NeighbouringCountriesResponse> check self.graphqlClient->execute(NeighbouringCountriesResponse, query, variables, httpHeaders);
    }
}

