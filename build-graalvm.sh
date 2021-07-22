#!/bin/bash

JDK_VERSION=$1
GRAALVM_VERSION="21.2.0"

apt update && apt install jq -y

downloadGraalVM() {
    JAVA_VERSION=$1
    echo "===================== Downloading GraalVM release ${GRAALVM_VERSION} for ${JAVA_VERSION}..."
    GRAALVM_NAME="graalvm-ce-${JAVA_VERSION}-linux-amd64-"${GRAALVM_VERSION}".tar.gz"
    wget -q `echo https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/${GRAALVM_NAME}`
    tar zxf `echo $GRAALVM_NAME`

    JDK_DIRECTORY=`ls -1d graalvm* | head -1`

    export JAVA_HOME=${CI_PROJECT_DIR}/${JDK_DIRECTORY}
    $JAVA_HOME/bin/gu install native-image
}

if [ "${JDK_VERSION}" == "jdk8" ]; then
    downloadGraalVM "java8"
elif [ "$JDK_VERSION" == "jdk11" ]; then
    downloadGraalVM "java11"
else
    echo "Need to provide a valid JDK version: jdk8, jdk11"
    exit 1
fi

# Copy GraalVM dist to new directory defined as artifact/cache
echo "Copying GraalVM dist to ${CI_PROJECT_DIR}/graal_dist..."
cp -R $JAVA_HOME/ $CI_PROJECT_DIR/graal_dist
