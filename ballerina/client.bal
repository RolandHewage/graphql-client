import ballerina/http;
import ballerina.graphql;

public isolated client class Client {
    final graphql:Client graphqlClient;
    final http:Client httpClient;
    # Gets invoked to initialize the `connector`.
    #
    # + serviceUrl - URL of the target service
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + return - An error at the failure of client initialization
    public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {}) returns error? {
        graphql:Client clientEp = check new (serviceUrl, clientConfig);
        self.graphqlClient = clientEp;

        http:Client httpEp = check new (serviceUrl, clientConfig);
        self.httpClient = httpEp;
    }

    remote isolated function countryByCode(string code) returns CountryByCodeResponse|error {
        string query = string `query CountryByCode($code: ID!) {
           country(code: $code) {
               name
           }
       }`;

        map<anydata> variables = {"code": code};

        CountryByCodeResponse response = check self.graphqlClient->execute(query, variables);
        return response;
    }

    remote isolated function countriesWithContinent(CountryFilterInput? filter = ())
                                                    returns CountriesWithContinentResponse|error {
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

        CountriesWithContinentResponse response = check self.graphqlClient->execute(query, variables);
        return response;
    }

    remote isolated function countryAndCountries(string code, CountryFilterInput? filter = ())
                                                returns CountryAndCountriesResponse|error {
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

        CountryAndCountriesResponse response = check self.graphqlClient->execute(query, variables);
        return response;
    }

    remote isolated function neighbouringCountries() returns NeighbouringCountriesResponse|error {
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

        NeighbouringCountriesResponse response = check self.graphqlClient->execute(query, variables);
        return response;
    }

    // New upgrade

    remote isolated function countryByCodeUpgraded(string code) returns CountryByCode|Error {
        string query = string `query CountryByCode($code: ID!) {
            country(code: $code) {
                name
            }
        }`;

        map<anydata> variables = {"code": code};

        CountryByCodeResponse response = check self.graphqlClient->execute(query, variables);
        if !(response?.errors is ()) {
            return error GraphQLError("GraphQL Error", data = response?.data, errors = response?.errors,
                extensions = response?.extensions);
        }
        return {
            data: response?.data,
            extensions: response?.extensions
        };
    }

    remote isolated function continentByCode(ContinentFilterInput? filter = ()) returns ContinentByCode|Error {
        string query = string `query Query($filter: ContinentFilterInput) {
            a: continents(filter: $filter) {
                name
            }
            b: continents(filter: null) {
                name
            }
        }`;

        map<anydata> variables = {"filter": filter};

        http:Request request = new;
        json graphqlPayload = check getGraphqlPayload(query, variables);
        request.setPayload(graphqlPayload);
        ContinentByCodeResponse response = check self.httpClient->post("", request, targetType = ContinentByCodeResponse);
        
        if !(response?.errors is ()) {
            return error GraphQLError("GraphQL Error", data = response?.data, errors = response?.errors,
                extensions = response?.extensions);
        }
        return {
            data: response?.data,
            extensions: response?.extensions
        };
    }
}

isolated function getGraphqlPayload(string query, map<anydata>? definedVariables = ())
                                    returns json|error {
    json variables = definedVariables.toJson();
    json graphqlPayload = {
        query: query,
        variables: variables
    };
    return graphqlPayload;
}

