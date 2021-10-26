// GraphQL request (Generic)

public type GraphQLClientRequest record {|
    string query;
    string? operationName?;
    map<anydata>? variables?;
    typedesc<record {}> responseType;
|};

// GraphQL response (Generic)

public type GraphQLClientResponse record {|
    record {}? data?;
    GraphQLClientError[]? errors?;
    map<anydata>? extensions?;
|};

// GraphQL error representation (Generic)

public type GraphQLClientError record {
    string message;
    GraphQLClientSourceLocation[] locations?;
    anydata[] path?;
    map<anydata> extensions?;
};

public type GraphQLClientSourceLocation record {
    int line?;
    int column?;
};

// Generated GraphQL response for country query (Specific)

public type CountryQueryResponse record {|
    CountryResult? data?;
    GraphQLClientError[]? errors?;
    map<anydata>? extensions?;
|};

// Generated GraphQL response for countries query (Specific)

public type CountriesQueryResponse record {|
    CountriesResult? data?;
    CountriesResult[]? errors?;
    map<anydata>? extensions?;
|};

// Generated types for country query (Specific)

type CountryResult record {|
    Country? country;
|};

type Country record {|
    string name;
|};

// Generated types for countries query (Specific)

type CountriesResult record {|
    Country1[] countries;
|};

type Country1 record {|
    string name;
    Continent continent;
|};

type Continent record {|
    Country2[] countries;
|};

type Country2 record {|
    Continent1 continent;
|};

type Continent1 record {|
    string name;
|};

// Generated Input Types

public type StringQueryOperatorInput record {
    string? eq?;
    string? ne?;
    string?[]? 'in?;
    string?[]? nin?;
    string? regex?;
    string? glob?;
};

public type CountryFilterInput record {
    StringQueryOperatorInput? code?;
    StringQueryOperatorInput? currency?;
    StringQueryOperatorInput? continent?;
};

// Generated types

// public type CountryData record {
//     Country? country?;
// };

// public type Country record {
//     string code?;
//     string name?;
//     string native?;
//     string phone?;
//     Continent continent?;
//     string? capital?;
//     string? currency?;
//     Language[] languages?;
//     string emoji?;
//     string emojiU?;
//     State[] states?;
// };

// public type State record {
//     string? code?;
//     string name?;
//     Country country?;
// };

// public type Continent record {
//     string code?;
//     string name?;
//     Country[] countries?;
// };

// public type Language record {
//     string code?;
//     string? name?;
//     string? native?;
//     boolean rtl?;
// };
