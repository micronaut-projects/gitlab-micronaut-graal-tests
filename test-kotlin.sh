#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-kotlin-graal/kotlin &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Kotlin)
EXPECTED_RESPONSE='{"msg":"Hello Kotlin"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
