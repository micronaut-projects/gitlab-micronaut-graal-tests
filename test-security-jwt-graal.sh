#!/bin/sh

apk add curl jq

$CI_PROJECT_DIR/micronaut-security-jwt-graal/security-jwt-graal &
sleep 3

RESPONSE=$(curl -s localhost:8080/ --write-out %{http_code})
EXPECTED_RESPONSE='401'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s -X POST -H 'Content-Type:application/json' -d '{}' localhost:8080/login | jq '._embedded | .errors | length')
EXPECTED_RESPONSE='4'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s -X POST -H 'Content-Type:application/json' -d '{"username":"sherlock","password":"password"}' localhost:8080/login | jq -r .token_type)
EXPECTED_RESPONSE='Bearer'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

ACCESS_TOKEN=$(curl -s -X POST -H 'Content-Type:application/json' -d '{"username":"sherlock","password":"password"}' localhost:8080/login | jq -r .access_token)
RESPONSE=$(curl -s -H "Authorization:Bearer ${ACCESS_TOKEN}" localhost:8080/)
EXPECTED_RESPONSE='sherlock'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
