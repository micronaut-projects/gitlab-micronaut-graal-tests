#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-security-session-graal/security-session &
sleep 3

# Unauthenticated request
RESPONSE=$(curl 'http://localhost:8080/login' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: SESSION=ABCDEF123456' --data 'username=&password=' | jq -r '.message')
EXPECTED_RESPONSE='Bad Request'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

# Authenticated request
RESPONSE=$(curl 'http://localhost:8080/login' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: SESSION=ABCDEF123456' --data 'username=sherlock&password=password' -c session.txt --write-out %{http_code})
EXPECTED_RESPONSE='303'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
if [ ! -f session.txt ]; then echo "session.txt should exist" && exit 1; fi
