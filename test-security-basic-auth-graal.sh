#!/bin/sh
set -x

apk add curl jq

$CI_PROJECT_DIR/micronaut-security-basic-auth-graal/security-basic-auth-graal &
sleep 3

RESPONSE=$(curl -s localhost:8080 --write-out %{http_code})
EXPECTED_RESPONSE='401'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080 --user sherlock:wrongpassword --write-out %{http_code})
EXPECTED_RESPONSE='401'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080 --user sherlock:password)
EXPECTED_RESPONSE='sherlock'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
