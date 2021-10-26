import ballerina/jballerina.java;
import ballerina/http;

public isolated client class GraphqlClient {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + serviceUrl - URL of the target service
    # + return - An error at the failure of client initialization
    public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {}) returns error? {
        http:Client httpEp = check new (serviceUrl, clientConfig);
        self.clientEp = httpEp;
        externalInit(self, httpEp);
    }

    // Generic Approach

    remote isolated function execute(GraphQLClientRequest graphqlRequest) returns GraphQLClientResponse|error {
        http:Request request = new;
        json graphqlPayload = check getGraphqlPayload(graphqlRequest.query, graphqlRequest?.variables);
        request.setPayload(graphqlPayload);
        json response = check self.clientEp-> post("", request, targetType = json);
        // map<json> responseData = <map<json>> check response?.data;
        GraphQLClientResponse graphQLClientResponse = {
            data: check (check response?.data).cloneWithType(graphqlRequest?.responseType)
        };
        return graphQLClientResponse;
    }

    // Suggested Approach

    remote isolated function executeQuery(string query, map<anydata> variables, typedesc<record{}> returnType = <>) 
    returns returnType|error = @java:Method {
        'class: "io.ballerinax.graphql.QueryProcessor",
        name: "executeQuery"
    } external;
}

isolated function getGraphqlPayload(string query, map<anydata>? definedVariables = ()) 
                                    returns json|error {
    json variables = definedVariables.toJson();
    json graphqlPayload = {
        query: query,
        variables: variables
    };
    return graphqlPayload;
}

isolated function externalInit(GraphqlClient caller, http:Client httpCaller) = @java:Method {
    'class: "io.ballerinax.graphql.QueryProcessor",
    name: "externalInit"
} external;
