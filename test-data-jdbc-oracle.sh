#!/bin/sh
set -x

echo "Waiting for Oracle to start..."
sleep 120

export DATASOURCES_DEFAULT_URL=jdbc:oracle:thin:@oraclehost:1521/xe
$CI_PROJECT_DIR/micronaut-data-jdbc-graal/data-jdbc-oracle -Doracle.jdbc.timezoneAsRegion=false &
sleep 120 # For some reason the app takes too long to start on CI when using Oracle.

RESPONSE=$(curl -s localhost:8080/owners)
EXPECTED_RESPONSE='[{"age":45,"name":"Fred","id":1},{"age":40,"name":"Barney","id":2}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/owners/Fred)
EXPECTED_RESPONSE='{"id":1,"name":"Fred","age":45}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s 'localhost:8080/pets?sort=name')
EXPECTED_RESPONSE='[{"name":"Baby Puss"},{"name":"Dino"},{"name":"Hoppy"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/pets/Dino | jq -c '{name, owner, type}')
EXPECTED_RESPONSE='{"name":"Dino","owner":{"id":1,"name":"Fred","age":45},"type":"DOG"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
