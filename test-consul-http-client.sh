#!/bin/sh
set -x

apk add curl

MICRONAUT_CONFIG_FILES=$CI_PROJECT_DIR/application-consul-http-client.yml $CI_PROJECT_DIR/micronaut-service-discovery-consul-http-client/service-discovery &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/api/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
