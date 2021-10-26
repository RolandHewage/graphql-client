import ballerina/io;
import ballerina/test;

// GraphqlClient graphqlClient = check new GraphqlClient(serviceUrl = "https://countries.trevorblades.com/");
Client baseClient = check new Client(serviceUrl = "https://countries.trevorblades.com/");

// Suggested Approach

@test:Config {}
function executeCountryQuery2() returns error? {
    CountryQueryResponse response = check baseClient->countryQuery1(code = "LK");
    io:println(response);
}

@test:Config {}
function executeCountriesQuery2() returns error? {
    StringQueryOperatorInput stringQueryOperatorInput = {
        eq: "LK"
    };

    CountryFilterInput filter = {
        code: stringQueryOperatorInput
    };

    CountriesQueryResponse response = check baseClient->countriesQuery1(filter = filter);
    io:println(response);
}

// Generic Approach

// @test:Config {}
// function executeCountryQuery1() returns error? {
//     GraphQLClientResponse response = check baseClient->countryQuery(code = "LK");
//     io:println(response);
// }

// @test:Config {}
// function executeCountriesQuery1() returns error? {
//     StringQueryOperatorInput stringQueryOperatorInput = {
//         eq: "LK"
//     };

//     CountryFilterInput filter = {
//         code: stringQueryOperatorInput
//     };

//     GraphQLClientResponse response = check baseClient->countriesQuery(filter = filter);
//     io:println(response);
// }

// Other Approaches

// @test:Config {}
// function executeCountryQuery2() returns error? {
//     CountryQueryResponse response = check baseClient->countryQuery1(code = "LK");
//     io:println(response);
// }

// @test:Config {}
// function executeCountriesQuery2() returns error? {
//     StringQueryOperatorInput stringQueryOperatorInput = {
//         eq: "LK"
//     };

//     CountryFilterInput filter = {
//         code: stringQueryOperatorInput
//     };

//     CountriesQueryResponse response = check baseClient->countriesQuery1(filter = filter);
//     io:println(response);
// }

// @test:Config {}
// function executeCountriesQuery3() returns error? {
//     StringQueryOperatorInput stringQueryOperatorInput = {
//         eq: "LK"
//     };

//     CountryFilterInput filter = {
//         code: stringQueryOperatorInput
//     };

//     GraphQLClientResponse? response = check baseClient->countriesQuery({ "filter": filter });
//     io:println(response);

// }

// @test:Config {}
// function executeCountryQuery3() returns error? {
//     GraphQLClientResponse? response = check baseClient->countryQuery({ "code": "LK" });
//     io:println(response);
// }

// @test:Config {}
// function executeCountriesQuery() returns error? {
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
//         variables: { "filter": filter },
//         responseType: CountriesResult
//     };

//     GraphQLClientResponse? response = check graphqlClient->execute(graphQLClientRequest);
//     io:println(response);

// }

// @test:Config {}
// function executeCountryQuery() returns error? {

//     string countryQuery = string `query($code: ID!) {
//         country(code: $code) {
//             name
//         }
//     }`;

//     GraphQLClientRequest graphQLClientRequest = {
//         query: countryQuery,
//         variables: { "code": "LK" },
//         responseType: CountryResult
//     };

//     GraphQLClientResponse? response = check graphqlClient->execute(graphQLClientRequest);
//     io:println(response);
// }
