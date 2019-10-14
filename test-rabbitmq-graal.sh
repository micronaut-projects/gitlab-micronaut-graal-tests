#!/bin/sh
set -x

apk add curl jq

MICRONAUT_CONFIG_FILES=$CI_PROJECT_DIR/application-micronaut-rabbitmq-graal.yml $CI_PROJECT_DIR/micronaut-rabbitmq-graal/graal-rabbitmq &
sleep 3

RESPONSE=$(curl -s localhost:8080/books-fireandforget/1491950358)
EXPECTED_RESPONSE='{"isbn":"1491950358","name":"Building Microservices"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/analytics | jq '.[0] | .count')
EXPECTED_RESPONSE='1'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
RESPONSE=$(curl -s localhost:8080/analytics | jq -r '.[0] | .bookIsbn')
EXPECTED_RESPONSE='1491950358'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/books-rpc)
EXPECTED_RESPONSE='[{"name":"Building Microservices"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
