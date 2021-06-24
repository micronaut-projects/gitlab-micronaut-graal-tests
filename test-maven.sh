#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-maven-graal/maven &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Maven)
EXPECTED_RESPONSE='{"msg":"Hello Maven"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

# OpenAPI
RESPONSE=$(curl -s http://localhost:8080/swagger/demo-0.0.yml)
EXPECTED_RESPONSE_CONTAINS='title: demo'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
EXPECTED_RESPONSE_CONTAINS='version: "0.0"'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
RESPONSE=$(curl -s http://localhost:8080/swagger/views/swagger-ui)
EXPECTED_RESPONSE_CONTAINS='swagger-ui'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
