#!/bin/bash

echo "Building micronaut-security-ldap-graal..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-security-ldap-graal
cd micronaut-security-ldap-graal
git checkout $APP_BRANCH
echo "------------------------------------"
git log -1
echo "------------------------------------"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
