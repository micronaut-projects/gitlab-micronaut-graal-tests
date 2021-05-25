#!/bin/sh
set -x

$CI_PROJECT_DIR/micronaut-graphql-graal/graphql &
sleep 3

RESPONSE=$(curl -s -X POST 'http://localhost:8080/graphql' -H 'content-type: application/json' --data-binary '{"query":"{ bookById(id:\"book-1\") { name, pageCount, author { firstName, lastName} }  }"}')
#https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings/1250279#1250279
EXPECTED_RESPONSE='{"data":{"bookById":{"name":"Harry Potter and the Philosopher'"'"'s Stone","pageCount":223,"author":{"firstName":"Joanne","lastName":"Rowling"}}}}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && exit 1; fi

RESPONSE=$(curl -s 'http://localhost:8080/graphiql')
EXPECTED_RESPONSE_CONTAINS='<title>GraphiQL</title>'
if [ "$RESPONSE" == "${RESPONSE%"$EXPECTED_RESPONSE_CONTAINS"*}" ]; then echo $RESPONSE && exit 1; fi
