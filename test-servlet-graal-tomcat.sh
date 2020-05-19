#!/bin/sh
set -x

apk add curl libstdc++

$CI_PROJECT_DIR/micronaut-servlet-graal/mn-servlet-tomcat-graal &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='{"msg":"Hello Micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
