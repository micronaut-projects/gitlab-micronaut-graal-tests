#!/bin/sh
set -x

apk add curl jq libstdc++

$CI_PROJECT_DIR/micronaut-grpc-graal/grpc-server &
$CI_PROJECT_DIR/micronaut-grpc-graal/grpc-client &
sleep 5

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
