#!/bin/bash

DB_DIALECT=$1

if [ -z "$DB_DIALECT" ]; then
    echo "Need to provide the database dialect: h2, postgres, mariadb"
    exit 1
fi

echo "Building micronaut-data-jpa-graal: ${DB_DIALECT}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-data-jpa-graal
cd micronaut-data-jpa-graal
git checkout ${CI_BUILD_REF_NAME}_${DB_DIALECT}
echo "Git commit: `git rev-parse HEAD`"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
