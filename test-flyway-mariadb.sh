#!/bin/sh
set -x

apk add curl jq libstdc++

export DATASOURCES_DEFAULT_URL=jdbc:mariadb://mariadbhost:3306/users
$CI_PROJECT_DIR/micronaut-flyway-graal/flyway-mariadb &
sleep 3

RESPONSE=$(curl -s localhost:8080/users)
EXPECTED_RESPONSE='[{"id":1,"username":"ilopmar","firstName":"Iván","lastName":"López"},{"id":2,"username":"graemerocher","firstName":"Graeme","lastName":"Rocher"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/flyway | jq -c '.[0] | [.migrations[] | {state, script} ]')
EXPECTED_RESPONSE='[{"state":"SUCCESS","script":"db/migration/V1__init.sql"},{"state":"SUCCESS","script":"db/migration/V2__testdata.sql"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
