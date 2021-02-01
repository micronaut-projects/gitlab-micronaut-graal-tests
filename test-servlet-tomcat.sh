#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-servlet-graal/servlet-tomcat &
sleep 3

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='{"msg":"Hello Micronaut"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
