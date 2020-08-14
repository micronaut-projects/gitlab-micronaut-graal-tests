#!/bin/sh
set -x

apk add curl jq libstdc++

MICRONAUT_CONFIG_FILES=$CI_PROJECT_DIR/application-elasticsearch.yml $CI_PROJECT_DIR/micronaut-elasticsearch-graal/elasticsearch &
sleep 3

curl -s -X POST -H 'Content-Type:application/json' -d '{"imdb":"matrix", "title":"The Matrix"}' localhost:8080/api/movies
sleep 5 # wait so ES has time to save and index the document

RESPONSE=$(curl -s "localhost:8080/api/movies?title=matrix" | jq -c '.hits[] | {index: .index, source: .source}')
EXPECTED_RESPONSE='{"index":"micronaut.movies","source":"{\"imdb\":\"matrix\",\"title\":\"The Matrix\"}"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi
