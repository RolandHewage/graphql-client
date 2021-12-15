import ballerina/http;
import ballerina.graphql;

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
public type ClientConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|http:CredentialsConfig|http:JwtIssuerConfig|http:OAuth2GrantConfig auth;
    # The HTTP version understood by the client
    string httpVersion = "1.1";
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects? followRedirects = ();
    # Configurations associated with request pooling
    http:PoolConfiguration? poolConfig = ();
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig? circuitBreaker = ();
    # Configurations associated with retrying
    http:RetryConfig? retryConfig = ();
    # Configurations associated with cookies
    http:CookieConfig? cookieConfig = ();
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    # SSL/TLS-related options
    http:ClientSecureSocket? secureSocket = ();
|};

public isolated client class AuthConfigClient {
    final graphql:Client graphqlClient;

    # Gets invoked to initialize the `connector`.
    #
    # + apiKeyConfig - API keys for authorization 
    # + serviceUrl - URL of the target service
    # + clientConfig - The configurations to be used when initializing the `connector`
    # + return - An error at the failure of client initialization
    public isolated function init(ClientConfig clientConfig, string serviceUrl) returns graphql:Error? {
        graphql:Client clientEp = check new (serviceUrl, clientConfig);
        self.graphqlClient = clientEp; 
        return;
    }

    remote isolated function countryByCode(string code) returns CountryByCodeResponse|graphql:Error {
        string query = string `query CountryByCode($code: ID!) {
            country(code: $code) {
                name
            }
        }`; 

        map<anydata> variables = {"code": code};

        return <CountryByCodeResponse> check self.graphqlClient->execute(CountryByCodeResponse, query, variables);
    }

    remote isolated function countriesWithContinent(CountryFilterInput? filter = ())
                                                    returns CountriesWithContinentResponse|graphql:Error {
        string query =
        string `query CountriesWithContinent($filter: CountryFilterInput) { 
           countries(filter: $filter) {   
               name
               continent {
                   countries {
                       name
                   }
               }
           }
       }`;

        map<anydata> variables = {"filter": filter};

        return <CountriesWithContinentResponse> check self.graphqlClient->execute(CountriesWithContinentResponse, query, variables);
    }

    remote isolated function countryAndCountries(string code, CountryFilterInput? filter = ())
                                                returns CountryAndCountriesResponse|graphql:Error {
        string query =
        string `query CountryAndCountries($code: ID!, $filter: CountryFilterInput) { 
           country(code: $code) {
               name
           }
           countries(filter: $filter) {   
               name
               continent {
                   countries {
                       continent {
                           name
                       }
                   }
               }
           }
       }`;

        map<anydata> variables = {"code": code, "filter": filter};

        return <CountryAndCountriesResponse> check self.graphqlClient->execute(CountryAndCountriesResponse, query, variables);
    }

    remote isolated function neighbouringCountries() returns NeighbouringCountriesResponse|graphql:Error {
        string query =
            string `query NeighbouringCountries { 
            countries(filter: {code: {eq: "LK"}}) {   
                name
                continent {
                    countries {
                        name
                    }
                }
            }
        }`;

        map<anydata> variables = {};

        return <NeighbouringCountriesResponse> check self.graphqlClient->execute(NeighbouringCountriesResponse, query, variables);
    }
}

