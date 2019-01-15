#!/bin/bash

echo "Building micronaut-basic-app..."

export JAVA_HOME=$CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home
export PATH=$JAVA_HOME/bin:$PATH
java -version
native-image --version

git clone https://github.com/micronaut-graal-tests/micronaut-basic-app
cd micronaut-basic-app
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
