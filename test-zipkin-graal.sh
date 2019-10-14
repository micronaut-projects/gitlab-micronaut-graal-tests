#!/bin/sh
set -x

apk add curl

MICRONAUT_CONFIG_FILES=$CI_PROJECT_DIR/application-micronaut-zipkin-graal.yml $CI_PROJECT_DIR/micronaut-zipkin-graal/zipkin-graal &
sleep 3

curl -s localhost:8080/config
curl -s http://openzipkin:9411/zipkin/api/v2/services
curl -s http://openzipkin:9411/zipkin/api/v2/spans?serviceName=zipkin-graal

RESPONSE=$(curl -s localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
