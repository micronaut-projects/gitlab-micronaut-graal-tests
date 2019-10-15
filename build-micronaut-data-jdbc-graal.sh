#!/bin/bash

DB_DIALECT=$1

if [ -z "$DB_DIALECT" ]; then
    echo "Need to provide the database dialect: h2, postgres"
    exit 1
fi

echo "Building micronaut-data-jdbc-graal: ${DB_DIALECT}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-data-jdbc-graal
cd micronaut-data-jdbc-graal
git checkout $DB_DIALECT
echo "Git commit: `git rev-parse HEAD`"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
