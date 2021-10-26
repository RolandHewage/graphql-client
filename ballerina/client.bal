import ballerina/http;

public isolated client class Client {
    final GraphqlClient baseClient;
    # Gets invoked to initialize the `connector`.
    #
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + serviceUrl - URL of the target service
    # + return - An error at the failure of client initialization
    public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {}) returns error? {
        GraphqlClient clientEp = check new GraphqlClient(serviceUrl, clientConfig);
        self.baseClient = clientEp;
    }

    remote isolated function countryQuery1(string code) returns CountryQueryResponse|error {
        string countryQuery = string `query($code: ID!) {
            country(code: $code) {
                name
            }
        }`;

        map<anydata> variables = { "code": code };

        CountryQueryResponse response = check self.baseClient->executeQuery(countryQuery, variables);
        return response;
    }

    remote isolated function countriesQuery1(CountryFilterInput? filter = ()) returns CountriesQueryResponse|error {
        string countriesQuery = string `query($filter: CountryFilterInput) {  
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

        map<anydata> variables = { "filter": filter };

        CountriesQueryResponse response = check self.baseClient->executeQuery(countriesQuery, variables);
        return response;
    }

    remote isolated function countryQuery(string code) returns GraphQLClientResponse|error {
        string countryQuery = string `query($code: ID!) {
            country(code: $code) {
                name
            }
        }`;

        map<anydata> variables = { "code": code };

        GraphQLClientRequest graphQLClientRequest = {
            query: countryQuery,
            variables: variables,
            responseType: CountryResult
        };

        GraphQLClientResponse response = check self.baseClient->execute(graphQLClientRequest);
        return response;
    }

    remote isolated function countriesQuery(CountryFilterInput? filter = ()) returns GraphQLClientResponse|error {
        string countriesQuery = string `query($filter: CountryFilterInput) {  
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

        map<anydata> variables = { "filter": filter };

        GraphQLClientRequest graphQLClientRequest = {
            query: countriesQuery,
            variables: variables,
            responseType: CountriesResult
        };

        GraphQLClientResponse response = check self.baseClient->execute(graphQLClientRequest);
        return response;
    }

    // remote isolated function countryQuery(map<anydata> variables) returns GraphQLClientResponse|error {
    //     string countryQuery = string `query($code: ID!) {
    //         country(code: $code) {
    //             name
    //         }
    //     }`;

    //     GraphQLClientRequest graphQLClientRequest = {
    //         query: countryQuery,
    //         variables: variables,
    //         responseType: CountryResult
    //     };

    //     GraphQLClientResponse response = check self.baseClient->execute(graphQLClientRequest);
    //     return response;
    // }

    // remote isolated function countriesQuery(map<anydata> variables) returns GraphQLClientResponse|error {
    //     string countriesQuery = string `query($filter: CountryFilterInput) {  
    //         countries(filter: $filter) {    
    //             name 
    //             continent {
    //                 countries {
    //                     continent {
    //                         name
    //                     }
    //                 }
    //             }
    //         }
    //     }`;

    //     StringQueryOperatorInput stringQueryOperatorInput = {
    //         eq: "LK"
    //     };

    //     CountryFilterInput filter = {
    //         code: stringQueryOperatorInput
    //     };

    //     GraphQLClientRequest graphQLClientRequest = {
    //         query: countriesQuery,
    //         variables: variables,
    //         responseType: CountriesResult
    //     };

    //     GraphQLClientResponse response = check self.baseClient->execute(graphQLClientRequest);
    //     return response;
    // }
}
