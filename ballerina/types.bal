// Generated GraphQL response for the CountryByCode query (Specific)
 
public type CountryByCodeResponse record {|
   CountryByCodeResult? data?;
   GraphQLClientError[]? errors?;
   map<anydata>? extensions?;
|};
 
// Generated GraphQL response for the CountriesWithContinent query (Specific)
 
public type CountriesWithContinentResponse record {|
   CountriesWithContinentResult? data?;
   GraphQLClientError[]? errors?;
   map<anydata>? extensions?;
|};
 
// Generated GraphQL response for the CountryAndCountries query (Specific)
 
public type CountryAndCountriesResponse record {|
   CountryAndCountriesResult? data?;
   GraphQLClientError[]? errors?;
   map<anydata>? extensions?;
|};
 
// Generated GraphQL response for the NeighbouringCountries query (Specific)
 
public type NeighbouringCountriesResponse record {|
   NeighbouringCountriesResult? data?;
   GraphQLClientError[]? errors?;
   map<anydata>? extensions?;
|};
 
// Generated types for the CountryByCode query (Specific)
 
type CountryByCodeResult record {|
   Country? country;
|};
 
type Country record {|
   string name;
|};
 
// Generated types for the CountriesWithContinent query (Specific)
 
type CountriesWithContinentResult record {|
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
   string name;
|};
 
// Generated types for the CountryAndCountries query (Specific)
 
type CountryAndCountriesResult record {|
   Country3? country;
   Country4[] countries;
|};
 
type Country3 record {|
   string name;
|};
 
type Country4 record {|
   string name;
   Continent1 continent;
|};
 
type Continent1 record {|
   Country5[] countries;
|};
 
type Country5 record {|
   Continent2 continent;
|};
 
type Continent2 record {|
   string name;
|};
 
// Generated types for the NeighbouringCountries query (Specific)
 
type NeighbouringCountriesResult record {|
   Country6[] countries;
|};
 
type Country6 record {|
   string name;
   Continent3 continent;
|};
 
type Continent3 record {|
   Country7[] countries;
|};
 
type Country7 record {|
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

// New upgrade

public type GraphQLErrorDetails record {|
   record {}? data?;
   GraphQLClientError[]? errors?;
   map<anydata>? extensions?;
|};

public type GraphQLError error<GraphQLErrorDetails>; 

public type Error GraphQLError|error;

public type CountryByCode record {|
   CountryByCodeResult? data?;
   map<anydata>? extensions?;
|};