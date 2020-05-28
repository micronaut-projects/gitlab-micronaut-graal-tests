#!/bin/bash

JDK_VERSION=$1

apt update && apt install jq -y

downloadGraalVMDevPreview() {
    TMP_JSON=`tempfile`
    curl -s https://api.github.com/repos/graalvm/graalvm-ce-dev-builds/releases > $TMP_JSON

    RELEASE_NAME=`jq -r '.[0] | .name' ${TMP_JSON}`
    GRAALVM_DOWNLOAD_URL=`jq -r '.[0].assets[] | select(.name | contains("graalvm-ce-'$1'-linux-amd64")) | .browser_download_url' ${TMP_JSON}`
    GRAALVM_NAME=`jq -r '.[0].assets[] | select(.name | contains("graalvm-ce-'$1'-linux-amd64")) | .name' ${TMP_JSON}`

    echo "===================== Downloading GraalVM release ${RELEASE_NAME}..."
    wget -q `echo $GRAALVM_DOWNLOAD_URL`
    tar zxf `echo $GRAALVM_NAME`

    TMP_NAME=`echo ${GRAALVM_NAME/linux-amd64-}`
    JDK_DIRECTORY=`echo ${TMP_NAME%.tar.gz}`

    export JAVA_HOME=${CI_PROJECT_DIR}/${JDK_DIRECTORY}
    $JAVA_HOME/bin/gu install native-image
}

if [ "${JDK_VERSION}" == "jdk8" ]; then
    downloadGraalVMDevPreview "java8"
elif [ "$JDK_VERSION" == "jdk11" ]; then
    downloadGraalVMDevPreview "java11"
else
    echo "Need to provide a valid JDK version: jdk8, jdk11"
    exit 1
fi

# Copy GraalVM dist to new directory defined as artifact/cache
echo "Copying GraalVM dist to ${CI_PROJECT_DIR}/graal_dist..."
cp -R $JAVA_HOME/ $CI_PROJECT_DIR/graal_dist

