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
    io:println(response);
}

@test:Config {}
function executeCountryAndCountries() returns error? {
    // Execute CountriesWithContinent query
    StringQueryOperatorInput stringQueryOperatorInput = {
        eq: "LK"
    };
    CountryFilterInput filter = {
        code: stringQueryOperatorInput
    };
    // Execute CountryAndCountries query
    CountryAndCountriesResponse response = check 'client->countryAndCountries(code = "LK", filter = filter);
}

@test:Config {}
function executeNeighbouringCountries() returns error? {
    // Execute NeighbouringCountries query
    NeighbouringCountriesResponse response = check 'client->neighbouringCountries();
}

