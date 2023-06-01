#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-aws-sdk2-graal/aws-s3 &
sleep 3

BUCKET_NAME="tmp-micronaut"-${CI_JOB_ID}

RESPONSE=$(curl -s -X POST localhost:8080/s3/buckets/$BUCKET_NAME | jq -r '.status')
EXPECTED_RESPONSE='200'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s -X GET localhost:8080/s3/buckets | jq '.buckets[]' | grep $BUCKET_NAME)
EXPECTED_RESPONSE="\"${BUCKET_NAME}\""
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s -X DELETE localhost:8080/s3/buckets/$BUCKET_NAME | jq -r '.status')
EXPECTED_RESPONSE='204'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
