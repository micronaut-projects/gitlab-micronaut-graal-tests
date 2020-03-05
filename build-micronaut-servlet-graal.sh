#!/bin/bash

SERVLET_ENGINE=$1

if [ -z "$SERVLET_ENGINE" ]; then
    echo "Need to provide the servlet engine: tomcat, jetty"
    exit 1
fi

echo "Building micronaut-servlet-graal: ${SERVLET_ENGINE}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-servlet-graal
cd micronaut-servlet-graal
git checkout $SERVLET_ENGINE
echo "Git commit: `git rev-parse HEAD`"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
