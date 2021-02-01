#!/bin/sh
set -x

export MQTT_CLIENT_SERVER_URI=tcp://mqtthost:1883
$CI_PROJECT_DIR/micronaut-mqtt-graal/mqtt-v5 &
sleep 10

curl localhost:8080/mqtt/send/Micronaut
sleep 1

RESPONSE=$(curl -s localhost:8080/mqtt/messages | jq -c '.[] | {text:.text}')
EXPECTED_RESPONSE='{"text":"MICRONAUT"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
