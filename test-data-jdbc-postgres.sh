#!/bin/sh
set -x

export DATASOURCES_DEFAULT_URL=jdbc:postgresql://postgreshost:5432/pets
$CI_PROJECT_DIR/micronaut-data-jdbc-graal/data-jdbc-postgres &
sleep 3

RESPONSE=$(curl -s localhost:8080/owners | jq -c '[.[] | {id, name, age}]')
EXPECTED_RESPONSE='[{"id":1,"name":"Fred","age":45},{"id":2,"name":"Barney","age":40}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/owners/Fred | jq -c '{id, name, age}')
EXPECTED_RESPONSE='{"age":45,"name":"Fred","id":1}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s 'localhost:8080/pets?sort=name' | jq -c '[.[] | {name}]')
EXPECTED_RESPONSE='[{"name":"Baby Puss"},{"name":"Dino"},{"name":"Hoppy"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/pets/Dino | jq -c '{name, owner: {id: .owner.id, name: .owner.name, age: .owner.age}, type}')
EXPECTED_RESPONSE='{"name":"Dino","owner":{"id":1,"name":"Fred","age":45},"type":"DOG"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
