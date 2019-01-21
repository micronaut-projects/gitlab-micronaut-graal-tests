#!/bin/bash

echo "Building micronaut-service-discovery-consul-http-client..."

export JAVA_HOME=$CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-service-discovery-consul-http-client
cd micronaut-service-discovery-consul-http-client
echo "Git commit: `git rev-parse HEAD`"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
