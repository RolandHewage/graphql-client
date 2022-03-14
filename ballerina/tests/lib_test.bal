import ballerina/io;
import ballerina/test;

Client 'client = check new (serviceUrl = "https://countries.trevorblades.com/");

// Suggested Approach

@test:Config {}
function executeCountryByCode() returns error? {
    // Execute CountryByCode query
    CountryByCodeResponse response = check 'client->countryByCode(code = "LK");
    io:println(response);
}

@test:Config {}
function executeCountriesWithContinent() returns error? {
    // Execute CountriesWithContinent query
    StringQueryOperatorInput stringQueryOperatorInput = {
        eq: "LK"
    };
    CountryFilterInput filter = {
        code: stringQueryOperatorInput
    };
    CountriesWithContinentResponse response = check 'client->countriesWithContinent(filter = filter);
    io:println(response.countries[0].continent.countries[0].name);
}

@test:Config {}
function executeCountryAndCountries() returns error? {
    // Execute CountryAndCountries query
    StringQueryOperatorInput stringQueryOperatorInput = {
        eq: "LK"
    };
    CountryFilterInput filter = {
        code: stringQueryOperatorInput
    };
    CountryAndCountriesResponse response = check 'client->countryAndCountries(code = "LK", filter = filter);
    io:println(response.countries[0].name);
}

@test:Config {}
function executeNeighbouringCountries() returns error? {
    // Execute NeighbouringCountries query
    NeighbouringCountriesResponse response = check 'client->neighbouringCountries();
    io:println(response.countries[0].continent.countries[0].name);
}


// // New upgrade

// @test:Config {}
// function executeCountryByCodeUpgraded() returns error? {
//     // Execute CountryByCode upgraded query
//     CountryByCode response = check 'client->countryByCodeUpgraded(code = "LK");
//     io:println(response);
// }

// @test:Config {}
// function executeContinentByCode() returns error? {
//     // Execute ContinentByCode query
//     StringQueryOperatorInput stringQueryOperatorInput = {
//         eq: "AS"
//     };
//     ContinentFilterInput filter = {
//         code: stringQueryOperatorInput
//     };

//     ContinentByCode|Error response = 'client->continentByCode(filter = filter);
//     if (response is GraphQLError) {
//         io:println(response.detail().errors);
//         test:assertFail("GraphQL error");
//     } else {
//         io:println(response);
//     }
// }

