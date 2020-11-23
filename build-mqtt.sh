#!/bin/bash

MQTT_VERSION=$1

if [ -z "${MQTT_VERSION}" ]; then
    echo "Need to provide the mqtt version: v3, v5"
    exit 1
fi

echo "Building micronaut-mqtt-graal: ${MQTT_VERSION}..."

export JAVA_HOME=$CI_PROJECT_DIR/graal_dist
export PATH=$JAVA_HOME/bin:$PATH
echo "------------------------------------"
java -version
echo "------------------------------------"
native-image --version
echo "------------------------------------"

git clone https://github.com/micronaut-graal-tests/micronaut-mqtt-graal
cd micronaut-mqtt-graal
git checkout ${APP_BRANCH}_${MQTT_VERSION}
echo "------------------------------------"
git log -1
echo "------------------------------------"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.console=plain"
./build-native-image.sh
