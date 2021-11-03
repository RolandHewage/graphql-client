import ballerina/jballerina.java;
import ballerina/http;
 
public isolated client class Client {
   # Gets invoked to initialize the `connector`.
   #
   # + serviceUrl - URL of the target service
   # + clientConfig - The configurations to be used when initializing the `connector`
   # + return - An error at the failure of client initialization
   public isolated function init(string serviceUrl, http:ClientConfiguration clientConfig = {})  
                                 returns error? {
       http:Client httpEp = check new (serviceUrl, clientConfig);             
       externalInit(self, httpEp);
   }
 
   remote isolated function execute(string query, map<anydata> variables, map<string|string[]>? headers = (),
                                    typedesc<record{}> returnType = <>)
                                    returns returnType|error = @java:Method {
       'class: "io.ballerinax.graphql.Processor",
       name: "executeQuery"
   } external;
}
 
isolated function externalInit(Client caller, http:Client httpCaller) = @java:Method {
   'class: "io.ballerinax.graphql.Processor",
   name: "externalInit"
} external;
