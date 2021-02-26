#!/bin/sh
set -x

export DATASOURCES_DEFAULT_URL=jdbc:mariadb://mariadbhost:3306/users
$CI_PROJECT_DIR/micronaut-liquibase-graal/liquibase-mariadb &
sleep 10

RESPONSE=$(curl -s localhost:8080/users)
EXPECTED_RESPONSE='[{"id":1,"username":"ilopmar","firstName":"Iván","lastName":"López"},{"id":2,"username":"graemerocher","firstName":"Graeme","lastName":"Rocher"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/liquibase | jq  -c '.[0] | [.changeSets[] | {execType, changeLog} ]')
EXPECTED_RESPONSE='[{"execType":"EXECUTED","changeLog":"db/changelog/01-create-users-table.xml"},{"execType":"EXECUTED","changeLog":"db/changelog/02-insert-users-data.xml"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
