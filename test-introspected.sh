#!/bin/sh
set -x

apk add curl libstdc++

$CI_PROJECT_DIR/micronaut-introspected-graal/mn-introspected-graal &
sleep 3

RESPONSE=$(curl -s localhost:8080/books)
EXPECTED_RESPONSE='{"name":"Micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
