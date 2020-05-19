#!/bin/sh
set -x

apk add curl jq libstdc++

$CI_PROJECT_DIR/micronaut-cache-graal/mn-cache-graal &
sleep 3

EXPECTED='{"month":"OCTOBER","headlines":["Micronaut AOP: Awesome flexibility without the complexity"]}'

RESPONSE=$(curl -s localhost:8080/OCTOBER)
if [ "$RESPONSE" != "$EXPECTED" ]; then echo $RESPONSE && exit 1; fi

# call twice to hit cache
RESPONSE=$(curl -s localhost:8080/OCTOBER)
if [ "$RESPONSE" != "$EXPECTED" ]; then echo $RESPONSE && exit 1; fi

exit 0
