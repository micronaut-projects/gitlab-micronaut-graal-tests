#!/bin/sh
set -x

apk add libstdc++

export MICRONAUT_FUNCTION_NAME=greeting
$(echo 'Micronaut' | $CI_PROJECT_DIR/micronaut-function-graal/function-graal > RESPONSE.txt)
RESPONSE=`cat RESPONSE.txt | tail -n 1`
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

export MICRONAUT_FUNCTION_NAME=greeting-pojo
$(echo '{"name":"Micronaut"}' | $CI_PROJECT_DIR/micronaut-function-graal/function-graal > RESPONSE.txt)
RESPONSE=`cat RESPONSE.txt | tail -n 1`
EXPECTED_RESPONSE='{"msg":"Hello Micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
