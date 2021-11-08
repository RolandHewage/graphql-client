import ballerina/http;

public isolated client class Client {
   final http:Client clientEp;
   # Gets invoked to initialize the `connector`.
   #
   # + serviceUrl - URL of the target service
   # + clientConfig - The configurations to be used when initializing the `connector`
   # + return - An error at the failure of client initialization
   public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {})  
                                 returns error? {
       http:Client httpEp = check new (serviceUrl, clientConfig);             
       self.clientEp = httpEp;
   }

   remote function execute(typedesc<record {| json...; |}> td, string query, map<anydata>? variables = (), 
                           map<string|string[]>? headers = ()) 
                           returns record {| json...; |}|ClientError|ServerError {
      http:Request request = new;
      json graphqlPayload = getGraphqlPayload(query, variables);
      request.setPayload(graphqlPayload);

      json|http:ClientError res = self.clientEp->post("", request, targetType = json);

      if res is http:ClientError {
         return error ClientError("");
      } else {
         if !(res.errors is ()) {
            json|error data = res.data;
            json|error errors = res.errors;
            json|error extensions = res.extensions;

            if ((data is json) && (extensions is json) && (errors is json)) {
               GraphQLClientError[] err = (errors).cloneWithType(GraphQLClientErrorList);
               return error ServerError("GraphQL Error", data = data, errors = err,
                  extensions = <map<json>> extensions);
            }
         }
      }

      // If json.Errors != (),
      // create and return ServerError

      // Else create record rec = json.data.cloneWithType(td)
      // Add extension to rec.
      // return rec
      return {};

   }
}
 