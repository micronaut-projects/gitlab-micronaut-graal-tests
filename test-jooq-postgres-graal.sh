#!/bin/sh
set -x

apk add curl jq libstdc++

export DATABASE_URL='jdbc:postgresql://postgreshost:5432/devDb'
export DATABASE_USER=devDb
export DATABASE_PASSWORD=devDb
export DATABASE_SCHEMA=public
$CI_PROJECT_DIR/micronaut-jooq-graal/mn-jooq-graal-postgres &
sleep 3

RESPONSE=$(curl -s localhost:8080/owners)
EXPECTED_RESPONSE='[{"id":1,"name":"Fred","age":45},{"id":2,"name":"Barney","age":40}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/owners/Fred)
EXPECTED_RESPONSE='{"id":1,"name":"Fred","age":45}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/pets)
EXPECTED_RESPONSE='[{"name":"Dino"},{"name":"Baby Puss"},{"name":"Hoppy"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/pets/Dino | jq -c '{name, owner, type}')
EXPECTED_RESPONSE='{"name":"Dino","owner":{"id":1,"name":"Fred","age":45},"type":"DOG"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
