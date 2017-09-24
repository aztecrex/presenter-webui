'use strict';

const IOT = require('aws-iot-device-sdk');
const AWSConfig = require('config/aws-configuration.js')

const clientId = function () {
    const min = 100000;
    const max = 999999;
    return "device" + Math.floor(Math.random() * (max - min) + min);
};




const theTopic = "Banana";

const createDevice = function (credentials, cb) {
    const mqtt = IOT.device({
        region: AWS.config.region,
        host: AWSConfiguration.host,
        clientId: clientId(),
        protocol: 'wss',
        maximumReconnectTimeMs: 8000,
        debug: true,
        accessKeyId: credentials.accessKeyId,
        secretKey: credentials.SecretKey,
        sessionToken: crecentials.SessionToken
    });
    mqtt.on('connect', function () {
        mqtt.subscribe(theTopic)
        cb("connected, subscribed to '" + theTopic + "'");
    });
    mqtt.on('reconnect', function () {
        cb("reconnect")
    });
    mqtt.on('message', function (topic, payload) {
        cb("message on '" + topic + "': " + payload.toString)
    });
};

const devices = [];

exports._update = function (credentials) {
    return function (onUpdate) {
        return function () {
            devices.push(createDevice(credentials, function (s) {
                onUpdate(s)();
            }));
        };
    };
};

exports._source = function(send) {
    return function () {
        setInterval(function() {
            const now = Date.now();
            console.log ("sending: " + now);
            send(now.toString())();
        }, 4000.0);
        return {};
    };
};

exports.times2 = function(send) {
    return function () {
        setInterval(function() {
            const now = Date.now();
            console.log ("sending: " + now);
            send(now.toString())();
        }, 4000.0);
        return {};
    };
};
