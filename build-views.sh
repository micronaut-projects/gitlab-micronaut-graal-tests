#!/bin/bash

TEMPLATE_TECHNOLOGY=$1

if [ -z "$TEMPLATE_TECHNOLOGY" ]; then
    echo "Need to provide the template technology: freemarker, handlebars, thymeleaf, velocity"
    exit 1
fi

echo "Building micronaut-views-graal: ${TEMPLATE_TECHNOLOGY}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-views-graal
cd micronaut-views-graal
git checkout 2.1.x_${TEMPLATE_TECHNOLOGY}
echo "------------------------------------"
git log -1
echo "------------------------------------"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
