'use strict';

const AWS = require('aws-sdk');
const AWSConfig = require('config/aws-configuration.js')


const config = AWS.config;
config.region = AWSConfig.region;
config.credentials = new AWS.CognitoIdentityCredentials({
    IdentityPoolId: AWSConfig.poolId
});

const credentials = config.credentials;
exports._config_credentials_get = function (onError) {
    return function (onSuccess) {
        return function() {
            credentials.get(function(error) {
                if (error) {
                    onError(error)();
                    return;
                }
                onSuccess(credentials.identityId)();
            });
        };
    };
}

exports._request = function (onError) {
    return function (onSuccess) {
        return function (message) {
            return function() {
                return setTimeout (function () {
                    console.log("async: " + message);
                    onSuccess("message sent: " + message)();
                }, 500);
            };
        };
    };
}

// exports._request = function (msg)
// { // accepts a request
//     return function (onError, onSuccess) { // and callbacks

//         setTimeout(function(){
//             Console.log(msg);
//             onSuccess("sent: " + msg);
//         }, 500);

//         return function (cancelError, cancelerError, cancelerSuccess) {
//             console.log("canceled");
//             cancelerSuccess();
//         }
//     //   var req = doNativeRequest(request, function (err, response) { // make the request
//     //     if (err != null) {
//     //       onError(err); // invoke the error callback in case of an error
//     //     } else {
//     //       onSuccess(response); // invoke the success callback with the reponse
//     //     }
//     //   });

//     //   // Return a canceler, which is just another Aff effect.
//     //   return function (cancelError, cancelerError, cancelerSuccess) {
//     //     req.cancel(); // cancel the request
//     //     cancelerSuccess(); // invoke the success callback for the canceler
//     //   };
//     };
// };
