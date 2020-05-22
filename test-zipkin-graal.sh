#!/bin/sh
set -x

apk add curl libstdc++

export TRACING_ZIPKIN_HTTP_URL=http://openzipkin:9411
$CI_PROJECT_DIR/micronaut-zipkin-graal/zipkin-graal &
sleep 3

RESPONSE=$(curl localhost:8080/hello/Micronaut)
EXPECTED_RESPONSE='Hello Micronaut'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

sleep 3 # Just wait until everything is updated in Zipkin
RESPONSE_ZIPKIN=$(curl http://openzipkin:9411/zipkin/api/v2/spans?serviceName=zipkin-graal)
EXPECTED_RESPONSE_ZIPKIN='["get /hello/{name}","sayhi"]'
if [ "$RESPONSE_ZIPKIN" != "$EXPECTED_RESPONSE_ZIPKIN" ]; then echo $RESPONSE_ZIPKIN && exit 1; fi
