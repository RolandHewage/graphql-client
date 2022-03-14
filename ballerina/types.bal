# Represents ContinentFilterInput
public type ContinentFilterInput record {
    StringQueryOperatorInput? code?;
};

# Represents CountryFilterInput
public type CountryFilterInput record {
    StringQueryOperatorInput? continent?;
    StringQueryOperatorInput? code?;
    StringQueryOperatorInput? currency?;
};

# Represents LanguageFilterInput
public type LanguageFilterInput record {
    StringQueryOperatorInput? code?;
};

# Represents StringQueryOperatorInput
public type StringQueryOperatorInput record {
    string?[]? nin?;
    string? regex?;
    string? ne?;
    string? glob?;
    string? eq?;
    string?[]? 'in?;
};

# Represents CountryByCodeResponse
type CountryByCodeResponse record {|
    map<json?> __extensions?;
    record {|
        string name;
    |}? country;
|};

# Represents CountriesWithContinentResponse
public type CountriesWithContinentResponse record {|
    map<json?> __extensions?;
    record {|
        string name;
        record {|
            record {|
                string name;
            |}[] countries;
        |} continent;
    |}[] countries;
|};

# Represents CountryAndCountriesResponse
public type CountryAndCountriesResponse record {|
    map<json?> __extensions?;
    record {|
        string name;
    |}? country;
    record {|
        string name;
        record {|
            record {|
                record {|
                    string name;
                |} continent;
            |}[] countries;
        |} continent;
    |}[] countries;
|};

# Represents NeighbouringCountriesResponse
public type NeighbouringCountriesResponse record {|
    map<json?> __extensions?;
    record {|
        string name;
        record {|
            record {|
                string name;
            |}[] countries;
        |} continent;
    |}[] countries;
|};

// // Generated GraphQL response for the CountryByCode query (Specific)
 
// public type CountryByCodeResponse record {|
//    CountryByCodeResult? data?;
//    GraphQLClientError[]? errors?;
//    map<anydata>? extensions?;
// |};
 
// // Generated GraphQL response for the CountriesWithContinent query (Specific)
 
// public type CountriesWithContinentResponse record {|
//    CountriesWithContinentResult? data?;
//    GraphQLClientError[]? errors?;
//    map<anydata>? extensions?;
// |};
 
// // Generated GraphQL response for the CountryAndCountries query (Specific)
 
// public type CountryAndCountriesResponse record {|
//    CountryAndCountriesResult? data?;
//    GraphQLClientError[]? errors?;
//    map<anydata>? extensions?;
// |};
 
// // Generated GraphQL response for the NeighbouringCountries query (Specific)
 
// public type NeighbouringCountriesResponse record {|
//    NeighbouringCountriesResult? data?;
//    GraphQLClientError[]? errors?;
//    map<anydata>? extensions?;
// |};
 
// // Generated types for the CountryByCode query (Specific)
 
// type CountryByCodeResult record {|
//    Country? country;
// |};
 
// type Country record {|
//    string name;
// |};
 
// // Generated types for the CountriesWithContinent query (Specific)
 
// type CountriesWithContinentResult record {|
//    Country1[] countries;
// |};
 
// type Country1 record {|
//    string name;
//    Continent continent;
// |};
 
// type Continent record {|
//    Country2[] countries;
// |};
 
// type Country2 record {|
//    string name;
// |};
 
// // Generated types for the CountryAndCountries query (Specific)
 
// type CountryAndCountriesResult record {|
//    Country3? country;
//    Country4[] countries;
// |};
 
// type Country3 record {|
//    string name;
// |};
 
// type Country4 record {|
//    string name;
//    Continent1 continent;
// |};
 
// type Continent1 record {|
//    Country5[] countries;
// |};
 
// type Country5 record {|
//    Continent2 continent;
// |};
 
// type Continent2 record {|
//    string name;
// |};
 
// // Generated types for the NeighbouringCountries query (Specific)
 
// type NeighbouringCountriesResult record {|
//    Country6[] countries;
// |};
 
// type Country6 record {|
//    string name;
//    Continent3 continent;
// |};
 
// type Continent3 record {|
//    Country7[] countries;
// |};
 
// type Country7 record {|
//    string name;
// |};
 
// // Generated Input Types
 
// public type StringQueryOperatorInput record {
//    string? eq?;
//    string? ne?;
//    string?[]? 'in?;
//    string?[]? nin?;
//    string? regex?;
//    string? glob?;
// };
 
// public type CountryFilterInput record {
//    StringQueryOperatorInput? code?;
//    StringQueryOperatorInput? currency?;
//    StringQueryOperatorInput? continent?;
// };
 
// // GraphQL error representation (Generic)
 
// public type GraphQLClientError record {
//    string message;
//    GraphQLClientSourceLocation[] locations?;
//    anydata[] path?;
//    map<anydata> extensions?;
// };
 
// public type GraphQLClientSourceLocation record {
//    int line?;
//    int column?;
// };

// // New upgrade

// public type GraphQLErrorDetails record {|
//    record {}? data?;
//    GraphQLClientError[]? errors;
//    map<anydata>? extensions?;
// |};

// public type GraphQLError error<GraphQLErrorDetails>; 

// public type Error GraphQLError|error;

// public type CountryByCode record {|
//    CountryByCodeResult? data;
//    map<anydata>? extensions?;
// |};

// // https://spec.graphql.org/June2018/#sec-Response-Format


// ////// Success scenario

// // (Data)

// // CountryByCode->data is not optional =>
// // If the operation included execution, the response map must contain an entry with key `data`. (https://spec.graphql.org/June2018/#sec-Response-Format)

// // Remove 
// // CountryByCode->data is nullable =>
// // If an error was encountered during the execution that prevented a valid response, the data entry in the response should be null. (https://spec.graphql.org/June2018/#sec-Data)

// // (Errors)

// // CountryByCode->errors is not present =>
// // If no errors were encountered during the requested operation, the errors entry should not be present in the result. (https://spec.graphql.org/June2018/#sec-Errors)
// // If the operation completed without encountering any errors, this entry must not be present. (https://spec.graphql.org/June2018/#sec-Response-Format)

// // (Extensions)

// // CountryByCode->extensions is optional & nullable =>
// // The response map may also contain an entry with key extensions. This entry, if set, must have a map as its value. This entry is reserved for implementors to extend the protocol however they see fit, and hence there are no additional restrictions on its contents.


// ////// Error scenario

// // (Data)

// // CountryByCodeResponse->data is optional =>
// // If an error was encountered before execution begins, the data entry should not be present in the result. (https://spec.graphql.org/June2018/#sec-Data)
// // If the operation failed before execution, due to a syntax error, missing information, or validation error, this entry must not be present. (https://spec.graphql.org/June2018/#sec-Response-Format)

// // CountryByCodeResponse->data is nullable =>
// // If an error was encountered during the execution that prevented a valid response, the data entry in the response should be null. (https://spec.graphql.org/June2018/#sec-Data)

// // (Errors)

// // CountryByCodeResponse->errors is not optional =>
// // If the data entry in the response is not present, the errors entry in the response must not be empty. It must contain at least one error. The errors it contains should indicate why no data was able to be returned. (https://spec.graphql.org/June2018/#sec-Errors)
// // If the data entry in the response is present (including if it is the value null), the errors entry in the response may contain any errors that occurred during execution. If errors occurred during execution, it should contain those errors.
// // If the operation encountered any errors, the response map must contain an entry with key errors. (https://spec.graphql.org/June2018/#sec-Response-Format)

// // CountryByCodeResponse->errors is not nullable =>
// // If the data entry in the response is not present, the errors entry in the response must not be empty. It must contain at least one error. The errors it contains should indicate why no data was able to be returned. (https://spec.graphql.org/June2018/#sec-Errors)
// // If the data entry in the response is present (including if it is the value null), the errors entry in the response may contain any errors that occurred during execution. If errors occurred during execution, it should contain those errors.

// // (Extensions)

// // CountryByCodeResponse->extensions is optional & nullable =>
// // The response map may also contain an entry with key extensions. This entry, if set, must have a map as its value. This entry is reserved for implementors to extend the protocol however they see fit, and hence there are no additional restrictions on its contents.


// // Generated GraphQL response for the CountinentByCode query (Specific)
// public type ContinentByCodeResponse record {|
//    ContinentByCodeResult? data?;
//    GraphQLClientError[]? errors?;
//    map<anydata>? extensions?;
// |};
// public type ContinentByCode record {|
//    ContinentByCodeResult? data;
//    map<anydata>? extensions?;
// |};

// type ContinentByCodeResult record {|
//    Continent4? continent;
// |};
 
// type Continent4 record {|
//    string name;
// |};

// public type ContinentFilterInput record {
//    StringQueryOperatorInput? code?;
// };