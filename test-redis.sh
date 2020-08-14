#!/bin/sh
set -x

apk add curl jq libstdc++

export REDIS_URI=redis://redishost
$CI_PROJECT_DIR/micronaut-redis-graal/redis &
sleep 3

curl -s localhost:8080/set

RESPONSE=$(curl -s localhost:8080/get)
EXPECTED_RESPONSE='Hello World'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

curl -s localhost:8080/command-set

RESPONSE=$(curl -s localhost:8080/command-get)
EXPECTED_RESPONSE='Hello World'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
