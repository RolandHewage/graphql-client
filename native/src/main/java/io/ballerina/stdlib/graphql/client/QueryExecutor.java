/*
 * Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.graphql.client;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;

/**
 * This class is used to execute a GraphQL query using the Ballerina GraphQL client.
 */
public class QueryExecutor {

    /**
    * Executes the GraphQL query when the corresponding Ballerina remote operation is invoked.
    */
    public static Object execute(Environment env, BObject client, BString query, Object variables, Object headers,
                                 BTypedesc targetType) {
        return invokeClientMethod(env, client, query, variables, headers, targetType, "executeQuery");
    }

    private static Object invokeClientMethod(Environment env, BObject client, BString query, Object variables, 
                                             Object headers, BTypedesc targetType, String methodName) {
        Object[] paramFeed = new Object[8];
        paramFeed[0] = targetType;
        paramFeed[1] = true;
        paramFeed[2] = query;
        paramFeed[3] = true;
        paramFeed[4] = variables;
        paramFeed[5] = true;
        paramFeed[6] = headers;
        paramFeed[7] = true;
        return invokeClientMethod(env, client, methodName, paramFeed);
    }

    private static Object invokeClientMethod(Environment env, BObject client, String methodName, Object[] paramFeed) {
        Future balFuture = env.markAsync();
//        Map<String, Object> propertyMap = getPropertiesToPropagate(env);
        env.getRuntime().invokeMethodAsync(client, methodName, null, null, new Callback() {
            @Override
            public void notifySuccess(Object result) {
                balFuture.complete(result);
            }

            @Override
            public void notifyFailure(BError bError) {
//                BError invocationError =
//                        HttpUtil.createHttpError("client method invocation failed: " + bError.getErrorMessage(),
//                                HttpErrorType.CLIENT_ERROR, bError);
                balFuture.complete(bError);
            }
        }, null, PredefinedTypes.TYPE_NULL, paramFeed);
        return null;
    }

//    private static Map<String, Object> getPropertiesToPropagate(Environment env) {
//        String[] keys = {CURRENT_TRANSACTION_CONTEXT_PROPERTY, KEY_OBSERVER_CONTEXT, SRC_HANDLER, MAIN_STRAND,
//                POOLED_BYTE_BUFFER_FACTORY, REMOTE_ADDRESS, ORIGIN_HOST};
//        Map<String, Object> subMap = new HashMap<>();
//        for (String key : keys) {
//            Object value = env.getStrandLocal(key);
//            if (value != null) {
//                subMap.put(key, value);
//            }
//        }
//        String strandParentFunctionName = Objects.isNull(env.getStrandMetadata()) ? null :
//                env.getStrandMetadata().getParentFunctionName();
//        if (Objects.nonNull(strandParentFunctionName) && strandParentFunctionName.equals("onMessage")) {
//            subMap.put(MAIN_STRAND, true);
//        }
//        return subMap;
//    }
}
