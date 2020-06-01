#!/bin/sh
set -x

apk add curl libstdc++

MICRONAUT_CONFIG_FILES=$CI_PROJECT_DIR/application-service-discovery-eureka.yml $CI_PROJECT_DIR/micronaut-service-discovery-eureka/service-discovery-eureka &
sleep 20 # For some reason the app takes too long to start on CI when using Eureka.

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/api/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
