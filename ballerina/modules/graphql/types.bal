public type Error ClientError|ServerError;

public type ClientError distinct error<record {| anydata body?; |}>;

public type ServerError distinct error<record {| json? data?; GraphQLClientError[] errors; map<json>? extensions?; |}>;

// GraphQL error representation (Generic)

public type GraphQLClientErrorArray GraphQLClientError[];
 
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
