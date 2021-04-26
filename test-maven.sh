#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-maven-graal/maven &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Maven)
EXPECTED_RESPONSE='{"msg":"Hello Maven"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
