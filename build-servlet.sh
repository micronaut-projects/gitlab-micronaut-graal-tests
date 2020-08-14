#!/bin/bash

SERVLET_ENGINE=$1

if [ -z "$SERVLET_ENGINE" ]; then
    echo "Need to provide the servlet engine: tomcat, jetty"
    exit 1
fi

echo "Building micronaut-servlet-graal: ${SERVLET_ENGINE}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-servlet-graal
cd micronaut-servlet-graal
git checkout ${CI_BUILD_REF_NAME}_${SERVLET_ENGINE}
echo "------------------------------------"
git log -1
echo "------------------------------------"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
