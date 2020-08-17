#!/bin/sh
set -x

apk add curl libstdc++

export CONSUL_CLIENT_DEFAULT_ZONE=consulhost:8500
$CI_PROJECT_DIR/micronaut-service-discovery-consul/service-discovery-consul &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/api/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
