#!/bin/sh
set -x

apk add curl jq

$CI_PROJECT_DIR/micronaut-security-cookie-graal/security-cookie-graal &
sleep 3

# Unauthenticated request
RESPONSE=$(curl 'http://localhost:8080/login' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: SESSION=ABCDEF123456' --data 'username=&password=' | jq -r '.message')
EXPECTED_RESPONSE='Bad Request'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

# Authenticated request
RESPONSE=$(curl 'http://localhost:8080/login' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: SESSION=ABCDEF123456' --data 'username=sherlock&password=password' -c cookie.txt --write-out %{http_code})
EXPECTED_RESPONSE='303'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
if [ ! -f cookie.txt ]; then echo "cookie.txt should exist" && exit 1; fi

RESPONSE=$(grep HttpOnly cookie.txt | awk {'print $7'} | cut -d. -f1,2 | sed 's/\./\n/g' | base64 -d | jq '.sub' | grep -v null)
EXPECTED_RESPONSE='"sherlock"'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

