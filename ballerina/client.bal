import ballerina/http;
import ballerina.graphql;

public isolated client class Client {
    final graphql:Client graphqlClient;
    # Gets invoked to initialize the `connector`.
    #
    # + serviceUrl - URL of the target service
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + return - An error at the failure of client initialization
    public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {}) returns graphql:Error? {
        graphql:Client clientEp = check new (serviceUrl, clientConfig);
        self.graphqlClient = clientEp; 
    }

    remote isolated function countryByCode(string code) returns CountryByCodeResponse|graphql:Error {
        string query = string `query CountryByCode($code: ID!) {
            country(code: $code) {
                name
            }
        }`; 

        map<anydata> variables = {"code": code};

        return <CountryByCodeResponse> check self.graphqlClient->execute(CountryByCodeResponse, query, variables);
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

        return <CountriesWithContinentResponse> check self.graphqlClient->execute(CountriesWithContinentResponse, query, variables);
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

        return <CountryAndCountriesResponse> check self.graphqlClient->execute(CountryAndCountriesResponse, query, variables);
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

        return <NeighbouringCountriesResponse> check self.graphqlClient->execute(NeighbouringCountriesResponse, query, variables);
    }
}

