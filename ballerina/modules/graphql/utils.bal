isolated function getGraphqlPayload(string query, map<anydata>? definedVariables = ())
                                    returns json {
    json variables = definedVariables.toJson();
    json graphqlPayload = {
        query: query,
        variables: variables
    };
    return graphqlPayload;
}
