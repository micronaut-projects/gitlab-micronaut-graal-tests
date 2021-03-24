#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-security-ldap-graal/security-ldap &
sleep 3

ACCESS_TOKEN=$(curl -s -X POST -H 'Content-Type:application/json' -d '{"username":"euler","password":"password"}' localhost:8080/login | jq -r .access_token)
RESPONSE=$(curl -s -H "Authorization:Bearer ${ACCESS_TOKEN}" localhost:8080/)
EXPECTED_RESPONSE='euler'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
