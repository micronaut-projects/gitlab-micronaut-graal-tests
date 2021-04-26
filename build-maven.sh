#!/bin/bash

echo "Building micronaut-maven-graal..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-maven-graal
cd micronaut-maven-graal
git checkout $APP_BRANCH
echo "------------------------------------"
git log -1
echo "------------------------------------"
./build-native-image.sh
