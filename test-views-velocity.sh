#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-views-graal/views-velocity &
sleep 3

RESPONSE=$(curl -s localhost:8080/)
EXPECTED_RESPONSE_CONTAINS='<img src="images/micronaut_mini_copy_tm.svg" width="400"/>'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/folder1/link1.html)
EXPECTED_RESPONSE_CONTAINS='<a href="https://micronaut.io/documentation.html">Micronaut documentation</a>'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/views/velocity)
EXPECTED_RESPONSE_CONTAINS="<span>Iván</span>"
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
EXPECTED_RESPONSE_CONTAINS="Velocity"
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s localhost:8080/views/velocity-view)
EXPECTED_RESPONSE_CONTAINS="<span>Iván</span>"
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
EXPECTED_RESPONSE_CONTAINS="Velocity"
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
