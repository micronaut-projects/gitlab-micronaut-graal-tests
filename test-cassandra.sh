#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-cassandra-graal/cassandra &
sleep 3

RESPONSE=$(curl localhost:8080/cassandra/info)
EXPECTED_RESPONSE='{"clusterName":"Test Cluster","releaseVersion":"3.11.10"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
