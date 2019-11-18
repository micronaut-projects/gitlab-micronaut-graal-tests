#!/bin/bash

TEMPLATE_TECHNOLOGY=$1

if [ -z "$TEMPLATE_TECHNOLOGY" ]; then
    echo "Need to provide the template technology: freemarker, handlebars, thymeleaf, velocity"
    exit 1
fi

echo "Building micronaut-views-graal: ${TEMPLATE_TECHNOLOGY}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-views-graal
cd micronaut-views-graal
git checkout $TEMPLATE_TECHNOLOGY
echo "Git commit: `git rev-parse HEAD`"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
