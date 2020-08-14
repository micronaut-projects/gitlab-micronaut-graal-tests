#!/bin/sh
set -x

apk add curl jq libstdc++

MICRONAUT_CONFIG_FILES=$CI_PROJECT_DIR/application-flyway-mariadb.yml $CI_PROJECT_DIR/micronaut-flyway-graal/flyway-mariadb &
sleep 3

RESPONSE=$(curl -s localhost:8080/users)
EXPECTED_RESPONSE='[{"id":1,"username":"ilopmar","firstName":"Iván","lastName":"López"},{"id":2,"username":"graemerocher","firstName":"Graeme","lastName":"Rocher"}]'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
