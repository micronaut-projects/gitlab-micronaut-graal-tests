#!/bin/sh
set -x

apk add curl jq libstdc++

$CI_PROJECT_DIR/micronaut-flyway-graal/flyway-h2 &
sleep 3

RESPONSE=$(curl -s localhost:8080/users)
EXPECTED_RESPONSE='[{"id":1,"username":"ilopmar","firstName":"Iván","lastName":"López"},{"id":2,"username":"graemerocher","firstName":"Graeme","lastName":"Rocher"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/flyway | jq -c '.[0] | [.migrations[] | {state, script} ]')
EXPECTED_RESPONSE='[{"state":"SUCCESS","script":"databasemigrations/V1__init.sql"},{"state":"SUCCESS","script":"databasemigrations/V2__testdata.sql"},{"state":"SUCCESS","script":"other/V3__testdata2.sql"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
