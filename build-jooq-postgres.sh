#!/bin/bash

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-jooq-graal
cd micronaut-jooq-graal
git checkout ${APP_BRANCH}_postgres
echo "------------------------------------"
git log -1
echo "------------------------------------"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"

# Needed for generating the jOOQ classes from the database schema
export DATABASE_URL='jdbc:postgresql://postgreshost:5432/devDb'
export DATABASE_USER=devDb
export DATABASE_PASSWORD=devDb
export DATABASE_SCHEMA=public

./build-native-image.sh
