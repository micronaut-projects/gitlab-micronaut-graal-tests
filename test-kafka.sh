#!/bin/sh
set -x

export KAFKA_SERVER=kafkahost:9092
$CI_PROJECT_DIR/micronaut-kafka-graal/kafka &
sleep 10

RESPONSE=$(curl -s localhost:8080/books/1491950358)
EXPECTED_RESPONSE='{"isbn":"1491950358","name":"Building Microservices"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/analytics | jq '.[0] | .count')
EXPECTED_RESPONSE='1'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
RESPONSE=$(curl -s localhost:8080/analytics | jq -r '.[0] | .bookIsbn')
EXPECTED_RESPONSE='1491950358'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
