#!/bin/sh
set -x

apk add curl jq

$CI_PROJECT_DIR/micronaut-management-graal/management-graal &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/health)
EXPECTED_RESPONSE='{"status":"UP"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s curl localhost:8080/info | jq -c '{branch: .git.branch, remote: .git.remote.origin.url}')
EXPECTED_RESPONSE='{"branch":"master","remote":"https://github.com/micronaut-graal-tests/micronaut-management-graal"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/metrics | jq '.names | length')
EXPECTED_RESPONSE='21'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/loggers | jq '.levels | length')
EXPECTED_RESPONSE='8'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
