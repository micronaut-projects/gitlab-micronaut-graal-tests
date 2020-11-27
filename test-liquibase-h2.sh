#!/bin/sh
set -x

apk add curl jq libstdc++

$CI_PROJECT_DIR/micronaut-liquibase-graal/liquibase-h2 &
sleep 3

RESPONSE=$(curl -s localhost:8080/users)
EXPECTED_RESPONSE='[{"id":1,"username":"ilopmar","firstName":"Iván","lastName":"López"},{"id":2,"username":"graemerocher","firstName":"Graeme","lastName":"Rocher"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/liquibase | jq  -c '.[0] | [.changeSets[] | {execType, changeLog} ]')
EXPECTED_RESPONSE='[{"execType":"EXECUTED","changeLog":"db/changelog/01-create-users-table.xml"},{"execType":"EXECUTED","changeLog":"db/changelog/02-insert-users-data.xml"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
