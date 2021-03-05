#!/bin/bash

AWS_SERVICE=$1

if [ -z "$AWS_SERVICE" ]; then
    echo "Need to provide the AWS service: s3, paramstore"
    exit 1
fi

echo "Building micronaut-aws-sdk2-graal: ${AWS_SERVICE}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-aws-sdk2-graal
cd micronaut-aws-sdk2-graal
git checkout ${APP_BRANCH}_${AWS_SERVICE}
echo "------------------------------------"
git log -1
echo "------------------------------------"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
