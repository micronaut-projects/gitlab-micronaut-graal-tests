#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-schedule-graal/schedule &
sleep 5

RESPONSE=$(curl -s localhost:8080/count)
EXPECTED_RESPONSE='3'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
