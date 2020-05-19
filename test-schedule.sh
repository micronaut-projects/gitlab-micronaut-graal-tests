#!/bin/sh
set -x

apk add curl libstdc++

$CI_PROJECT_DIR/micronaut-schedule-graal/mn-schedule-graal &
sleep 5

RESPONSE=$(curl -s localhost:8080/count)
EXPECTED_RESPONSE='3'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
