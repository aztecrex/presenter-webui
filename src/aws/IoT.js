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
    const thing = 'Slides';
    var registered = false
    const shadow = IOT.thingShadow({
        region: AWSConfig.region,
        host: AWSConfig.host,
        clientId: clientId(),
        protocol: 'wss',
        maximumReconnectTimeMs: 8000,
        debug: true,
        accessKeyId: credentials.AccessKeyId,
        secretKey: credentials.SecretKey,
        sessionToken: credentials.SessionToken
    });
    shadow.on('connect', function () {
        shadow.subscribe(theTopic)
        console.log("connected, subscribed to '" + theTopic + "'");
        if (!registered) {
            shadow.register(thing, {
                persistentSubscribe: true
            });
            console.log("registered thing '" + thing + "'");
            registered = true;
        }
    });
    shadow.on('reconnect', function () {
        console.log("reconnect")
    });
    shadow.on('message', function (topic, payload) {
        console.log("message on '" + topic + "': " + payload.toString())
    });
    shadow.on('delta', function (name, stateObj) {
        const page = stateObj.state.page || 1;
        const url = stateObj.state.url || "http://www.whatever.net/wat";
        const update = {
            page: page,
            url: url
        }
        // console.log("DELTA: " + JSON.stringify(stateObj));
        // console.log("DELTA UPDATE" + JSON.stringify(update));
        cb({
            update: update,
            thing: name,
            source: stateObj
        });
    });
    shadow.on('status', function (name, type, token, stateObj) {
        const page = stateObj.state.delta.page || 1;
        const url = stateObj.state.delta.url || "http://www.whatever.net/wat";
        const update = {
            page: page,
            url: url
        }
        // console.log("STATUS: " + JSON.stringify(stateObj));
        // console.log("STATUS UPDATE" + JSON.stringify(update));
        cb({
            update: update,
            thing: name,
            token: token,
            type: type,
            source: stateObj
        });
    });

    setTimeout( function () {
        const code = shadow.get(thing);
        // console.log("GET CODE:" + code);
    }, 3000);
};

const devices = [];

exports._updates = function (credentials) {
    return function (onUpdate) {
        return function () {
            devices.push(createDevice(credentials, function (s) {
                onUpdate(s)();
            }));
        };
    };
};

exports._pageUpdate = function (update) {
    return update.update.page;
};
exports._urlUpdate = function (update) {
    // console.log ("CONVERTING: " + JSON.stringify(update));
    return update.update.url;
};
exports._rawUpdate = function (update) {
    return JSON.stringify(update);
};
