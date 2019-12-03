#!/bin/sh
set -x

apk add curl

$CI_PROJECT_DIR/micronaut-basic-app/basic-app &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='{"msg":"Hello Micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/status/annotation --write-out %{http_code})
EXPECTED_RESPONSE='400'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/status/http-status --write-out %{http_code})
EXPECTED_RESPONSE='400'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/status/http-response-body --write-out %{http_code})
EXPECTED_RESPONSE='{"message":"Error message","code":400}400'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/status/mutable-http-response-body --write-out %{http_code})
EXPECTED_RESPONSE='{"message":"Error message","code":400}400'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
