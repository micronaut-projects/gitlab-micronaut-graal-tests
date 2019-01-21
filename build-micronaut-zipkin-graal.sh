#!/bin/bash

echo "Building micronaut-zipkin-graal..."

export JAVA_HOME=$CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-zipkin-graal
cd micronaut-zipkin-graal
git checkout test
echo "Git commit: `git rev-parse HEAD`"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
