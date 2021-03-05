#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-aws-sdk2-graal/aws-paramstore &
sleep 3

RESPONSE=$(curl -s -X POST -H "Content-Type: application/json"  -d '{"name":"/foo/bar", "type":"String", "value":"micronaut"}' http://localhost:8080/paramStore/ | jq -r '.status')
EXPECTED_RESPONSE='200'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s -X GET localhost:8080/paramStore | jq -c '.parameters[0]')
EXPECTED_RESPONSE='{"name":"/foo/bar","type":"String","value":"micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s -X DELETE localhost:8080/paramStore/foo/bar | jq -r '.status')
EXPECTED_RESPONSE='200'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
