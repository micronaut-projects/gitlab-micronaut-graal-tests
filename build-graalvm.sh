#!/bin/bash

JDK_VERSION=$1

# Change these variables to test different versions/snapshots
GRAALVM_RELEASE=20.2.0-dev-20200527_0158
GRAALVM_VERSION=20.2.0-dev

jdk8() {
    echo "Downloading GraalVM release for JDK8..."
    wget -q https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/${GRAALVM_RELEASE}/graalvm-ce-java8-linux-amd64-${GRAALVM_VERSION}.tar.gz
    tar zxf graalvm-ce-java8-linux-amd64-${GRAALVM_VERSION}.tar.gz
    export JAVA_HOME=${CI_PROJECT_DIR}/graalvm-ce-java8-${GRAALVM_VERSION}
    $JAVA_HOME/bin/gu install native-image
}

jdk11() {
    echo "Downloading GraalVM release for JDK11..."
    wget -q https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/${GRAALVM_RELEASE}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz
    tar zxf graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz
    export JAVA_HOME=${CI_PROJECT_DIR}/graalvm-ce-java11-${GRAALVM_VERSION}
    $JAVA_HOME/bin/gu install native-image
}

if [ "${JDK_VERSION}" == "jdk8" ]; then
    jdk8
elif [ "$JDK_VERSION" == "jdk11" ]; then
    jdk11
else
    echo "Need to provide a valid JDK version: jdk8, jdk11"
    exit 1
fi

# Copy GraalVM dist to new directory defined as artifact/cache
echo "Copying GraalVM dist to ${CI_PROJECT_DIR}/graal_dist..."
cp -R $JAVA_HOME/ $CI_PROJECT_DIR/graal_dist

