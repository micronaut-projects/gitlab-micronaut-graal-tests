#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-basic-app/basic-app &
sleep 3

# Basic
RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='{"msg":"Hello Micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

# HTTP Status
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

# HTTP Client
RESPONSE=$(curl -s localhost:8080/bintray/packages)
EXPECTED_RESPONSE_CONTAINS='{"name":"core","linked":false}'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/bintray/packages-lowlevel)
EXPECTED_RESPONSE_CONTAINS='{"name":"core","linked":false}'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi

# Micronaut Version
RESPONSE=$(curl -s localhost:8080/version)
EXPECTED_RESPONSE_CONTAINS='-SNAPSHOT'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi

# Enum
RESPONSE=$(curl -s localhost:8080/color/blue)
EXPECTED_RESPONSE_CONTAINS='BLUE'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
