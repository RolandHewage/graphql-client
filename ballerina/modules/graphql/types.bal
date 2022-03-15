// GraphQL client related errors representation

# Represents GraphQL client related generic errors.
public type Error ClientError|ServerError;

# Represents GraphQL client side or network level errors.
public type ClientError distinct error<record {| anydata body?; |}>;

# Represents GraphQL API response during GraphQL API server side errors.
public type ServerError distinct error<record {| json? data?; GraphQLError[] errors; map<json>? extensions?; |}>;

# Represents a list of GraphQL API server side errors.
public type GraphQLErrorArray GraphQLError[];
 
# Represents a GraphQL API server side error.
#
# + message - A string description of the error
# + locations - A list of locations in the requested GraphQL document associated with the error
# + path - A particular field in the GraphQL result associated with the error
# + extensions - Additional information to errors
public type GraphQLError record {
   string message;
   GraphQLSourceLocation[] locations?;
   anydata[] path?;
   map<anydata> extensions?;
};
 
# Represents a location in the requested GraphQL document associated with the error.
#
# + line - A line number starting from 1 which describe the beginning of an associated syntax element
# + column - A column number starting from 1 which describe the beginning of an associated syntax element
public type GraphQLSourceLocation record {
   int line?;
   int column?;
};

public type OperationResponse record {| anydata...; |}|record {| anydata...; |}?|record {| anydata...; |}[]|record {| anydata...; |}[]?;

public type GenericResponse record {|
   map<json?> __extensions?;
   OperationResponse ...;
|};
