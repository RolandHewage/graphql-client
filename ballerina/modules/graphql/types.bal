public type ClientError distinct error;

public type ServerError error<record {| json? data?; GraphQLClientError[] errors; map<json>? extensions?; |}>;

public type GraphQLClientErrorList GraphQLClientError[];

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
