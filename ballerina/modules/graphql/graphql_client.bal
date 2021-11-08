import ballerina/http;

public isolated client class Client {
   final http:Client clientEp;
   # Gets invoked to initialize the `connector`.
   #
   # + serviceUrl - URL of the target service
   # + clientConfig - The configurations to be used when initializing the `connector`
   # + return - An error at the failure of client initialization
   public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {})  
                                 returns Error? {
      do {
         http:Client httpEp = check new (serviceUrl, clientConfig);             
         self.clientEp = httpEp;
      } on fail var e {
         return error ClientError("GraphQL Client Error", e);
      }
   }

   remote isolated function execute(typedesc<record {| json...; |}> returnType, string query, 
                                    map<anydata>? variables = (), map<string|string[]>? headers = ()) 
                                    returns record {| json...; |}|Error {
      http:Request request = new;
      json graphqlPayload = getGraphqlPayload(query, variables);
      request.setPayload(graphqlPayload);

      json|http:ClientError httpResponse = self.clientEp->post("", request, headers = headers);

      do {
         if httpResponse is http:ClientError {
            if (httpResponse is http:ApplicationResponseError) {
               anydata data = check httpResponse.detail().get("body").ensureType(anydata);
               return error ClientError("GraphQL Client Error", body = data);
            }
            return error ClientError("GraphQL Client Error", httpResponse);
         } else {
            map<json> responseMap = <map<json>> httpResponse;

            if (responseMap.hasKey("errors")) {
               GraphQLClientError[] errors = check responseMap.get("errors").cloneWithType(GraphQLClientErrorArray);
               
               if (responseMap.hasKey("data") && !responseMap.hasKey("extensions")) {
                  return error ServerError("GraphQL Server Error", data = responseMap.get("data"), errors = errors);
               } else if (responseMap.hasKey("extensions") && !responseMap.hasKey("data")) {
                  map<json>? extensionsMap = 
                     (responseMap.get("extensions") is ()) ? () : <map<json>> responseMap.get("extensions");
                  return error ServerError("GraphQL Server Error", errors = errors, extensions = extensionsMap);
               } else if (responseMap.hasKey("data") && responseMap.hasKey("extensions")) {
                  map<json>? extensionsMap = 
                     (responseMap.get("extensions") is ()) ? () : <map<json>> responseMap.get("extensions") ;
                  return error ServerError("GraphQL Server Error", data = responseMap.get("data"), errors = errors, 
                     extensions = extensionsMap);
               } else {
                  return error ServerError("GraphQL Server Error", errors = errors);
               }
            } else {
               json responseData = responseMap.get("data");
               if (responseMap.hasKey("extensions")) {
                  responseData = check responseData.mergeJson({ "extensions" : responseMap.get("extensions") });
               }
               record {| json...; |} response = check responseData.cloneWithType(returnType);
               return response;
            }
         }
      } on fail var e {
         return error ClientError("GraphQL Client Error", e);
      }
   }
}
 