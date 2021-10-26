package io.ballerinax.graphql;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import org.ballerinalang.net.http.HttpErrorType;
import org.ballerinalang.net.http.HttpUtil;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import static io.ballerina.runtime.api.constants.RuntimeConstants.CURRENT_TRANSACTION_CONTEXT_PROPERTY;
import static io.ballerina.runtime.observability.ObservabilityConstants.KEY_OBSERVER_CONTEXT;
import static io.ballerinax.graphql.Constants.APPLICATION_JSON;
import static io.ballerinax.graphql.Constants.CONTENT_TYPE;
import static io.ballerinax.graphql.Constants.GRAPHQL_HTTP_CLIENT;
import static io.ballerinax.graphql.Constants.HTTP_POST;
import static io.ballerinax.graphql.Constants.HTTP_REQUEST;
import static io.ballerinax.graphql.Constants.MEDIA_TYPE;
import static io.ballerinax.graphql.Constants.PATH;
import static io.ballerinax.graphql.Constants.QUERY;
import static io.ballerinax.graphql.Constants.SERVICE_URL;
import static io.ballerinax.graphql.Constants.VARIABLES;
import static org.ballerinalang.net.http.HttpConstants.ORIGIN_HOST;
import static org.ballerinalang.net.http.HttpConstants.POOLED_BYTE_BUFFER_FACTORY;
import static org.ballerinalang.net.http.HttpConstants.REMOTE_ADDRESS;
import static org.ballerinalang.net.http.HttpConstants.SRC_HANDLER;

public class QueryProcessor {
    public static void externalInit(Environment env, BObject client, BObject httpClient) {
        // Enable Ballerina HTTP client
        client.addNativeData("HttpClient", httpClient);

        // Enable Java HTTP client
//        HttpClient httpclient = HttpClient.newHttpClient();
//        client.addNativeData(GRAPHQL_HTTP_CLIENT, httpclient);
    }

    /**
     * Executes the native query when the corresponding Ballerina remote operation is invoked
     */
    public static Object executeQuery(Environment env, BObject client, BString query, BMap<BString, Object> variables,
                                      BTypedesc ballerinaType) {
        String requestPayload = buildRequestPayload(query, variables);
        System.out.println(requestPayload);

        // Enable if Java HTTP client is used
//        createHttpRequest(requestPayload, client);

        makeHttpPostRequest(env, client, ballerinaType, requestPayload);
        return null;
    }

    /**
     * Build the GraphQL request payload using the query & the user defined record
     */
    private static String buildRequestPayload(BString query, BMap<BString, Object> variables) {
        JSONObject graphqlJsonPayload = new JSONObject();
        graphqlJsonPayload.put(QUERY, query);
        graphqlJsonPayload.put(VARIABLES, toStringMap(variables));
        return graphqlJsonPayload.toString();
    }

    /**
     * Create HTTP request object with the GraphQL payload attached to it
     */
    private static void createHttpRequest(String graphqlPayload, BObject client) {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(SERVICE_URL))
                .headers(CONTENT_TYPE, APPLICATION_JSON)
                .POST(HttpRequest.BodyPublishers.ofString(graphqlPayload, StandardCharsets.UTF_8))
                .build();
        client.addNativeData(HTTP_REQUEST, request);
    }

    /**
     * Make an HTTP POST request
     */
    private static void makeHttpPostRequest(Environment env, BObject client, BTypedesc ballerinaType, String requestPayload) {
        // Enable if Java HTTP client is used
//        sendRequestUsingJavaHttp(client);
        // Enable if Ballerina HTTP client is used
        sendRequestUsingBallerinaHttp(env, client, ballerinaType, requestPayload);
    }

    private static void sendRequestUsingJavaHttp(BObject client) {
        HttpClient httpClient = (HttpClient) client.getNativeData(GRAPHQL_HTTP_CLIENT);
        HttpRequest httpRequest = (HttpRequest) client.getNativeData(HTTP_REQUEST);
        try {
            // Use the client to send the request
            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode()==200) {
                // The response:
                System.out.println(response.body());
                JSONObject jo = new JSONObject(response.body());
            }
        } catch (IOException | InterruptedException e) {
//            log.error("Exception Occurred: ", e);
        }
    }

    private static void sendRequestUsingBallerinaHttp(Environment env, BObject client, BTypedesc ballerinaType,
                                                      String requestPayload) {
        BObject httpClient = (BObject) client.getNativeData("HttpClient");

        Object[] paramFeed = new Object[10];
        paramFeed[0] = PATH;
        paramFeed[1] = true;
        paramFeed[2] = StringUtils.fromString(requestPayload);
        paramFeed[3] = true;
        paramFeed[4] = null;
        paramFeed[5] = true;
        paramFeed[6] = MEDIA_TYPE;
        paramFeed[7] = true;
        paramFeed[8] = ballerinaType;
        paramFeed[9] = true;

        Object response = invokeClientMethod(env, httpClient, HTTP_POST, paramFeed);
    }

    private static Object invokeClientMethod(Environment env, BObject client, String methodName, Object[] paramFeed) {
        Future balFuture = env.markAsync();
        Map<String, Object> propertyMap = getPropertiesToPropagate(env);
        env.getRuntime().invokeMethodAsync(client, methodName, null, null, new Callback() {
            @Override
            public void notifySuccess(Object result) {
                balFuture.complete(result);
            }

            @Override
            public void notifyFailure(BError bError) {
                BError invocationError =
                        HttpUtil.createHttpError("client method invocation failed: " + bError.getErrorMessage(),
                                HttpErrorType.CLIENT_ERROR, bError);
                balFuture.complete(invocationError);
            }
        }, propertyMap, PredefinedTypes.TYPE_NULL, paramFeed);
        return null;
    }

    private static Map<String, Object> getPropertiesToPropagate(Environment env) {
        String[] keys = {CURRENT_TRANSACTION_CONTEXT_PROPERTY, KEY_OBSERVER_CONTEXT, SRC_HANDLER,
                POOLED_BYTE_BUFFER_FACTORY, REMOTE_ADDRESS, ORIGIN_HOST};
        Map<String, Object> subMap = new HashMap<>();
        for (String key : keys) {
            Object value = env.getStrandLocal(key);
            if (value != null) {
                subMap.put(key, value);
            }
        }
        return subMap;
    }

    /**
     * Convert BMap to String Map.
     *
     * @param map Input BMap used to convert to Map.
     * @return Converted Map object.
     */
    public static Map<String, String> toStringMap(BMap map) {
        Map<String, String> returnMap = new HashMap<>();
        if (map != null) {
            for (Object aKey : map.getKeys()) {
                returnMap.put(aKey.toString(), map.get(aKey).toString());
            }
        }
        return returnMap;
    }

    public static JSONObject getJsonFromMap(Map<String, Object> map) {
        JSONObject jsonData = new JSONObject();
        for (String key : map.keySet()) {
            Object value = map.get(key);
            if (value instanceof Map<?, ?>) {
                value = getJsonFromMap((Map<String, Object>) value);
            }
            jsonData.put(key, value);
        }
        return jsonData;
    }

    public static JSONObject getJsonFromMap(BMap map) {
        JSONObject jsonData = new JSONObject();
        for (Object key : map.getKeys()) {
            Object value = map.get(key.toString());
            if (value instanceof BMap) {
                value = getJsonFromMap((BMap) value);
            }
            jsonData.put(key.toString(), value);
        }
        return jsonData;
    }

}
