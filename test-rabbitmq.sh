#!/bin/sh
set -x

# Configuration using Environment Variables because Gitlab CI injects a RABBITMQ_PORT that messes up everything so
# we need to override it
export RABBITMQ_URI=amqp://rabbitmqhost:5672
export RABBITMQ_PORT=5672
$CI_PROJECT_DIR/micronaut-rabbitmq-graal/rabbitmq &
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

RESPONSE=$(curl -s localhost:8080/metrics | jq -r '.names[]' | grep rabbitmq | wc -l)
EXPECTED_RESPONSE='10'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
