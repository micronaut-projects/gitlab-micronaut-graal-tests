#!/bin/sh
set -x

apk add curl jq libstdc++

export DATASOURCES_DEFAULT_URL=jdbc:postgresql://postgreshost:5432/users
$CI_PROJECT_DIR/micronaut-flyway-graal/flyway-postgres &
sleep 3

RESPONSE=$(curl -s localhost:8080/users)
EXPECTED_RESPONSE='[{"id":1,"username":"ilopmar","firstName":"Iván","lastName":"López"},{"id":2,"username":"graemerocher","firstName":"Graeme","lastName":"Rocher"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
