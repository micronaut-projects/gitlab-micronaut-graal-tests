#!/bin/bash

JDK_VERSION=$1

jdk8() {
    echo "Building GraalVM for JDK 8"
    wget -q https://github.com/graalvm/graal-jvmci-8/releases/download/jvmci-20.2-b01/openjdk-8u252+09-jvmci-20.2-b01-linux-amd64.tar.gz
    tar zxf openjdk-8u252+09-jvmci-20.2-b01-linux-amd64.tar.gz
    export JAVA_HOME=${CI_PROJECT_DIR}/openjdk1.8.0_252-jvmci-20.2-b01
}

jdk11() {
    echo "Building GraalVM for JDK 11"
    wget -q https://github.com/graalvm/labs-openjdk-11/releases/download/jvmci-20.1-b02/labsjdk-ce-11.0.7+10-jvmci-20.1-b02-linux-amd64.tar.gz
    tar zxf labsjdk-ce-11.0.7+10-jvmci-20.1-b02-linux-amd64.tar.gz
    export JAVA_HOME=${CI_PROJECT_DIR}/labsjdk-ce-11.0.7-jvmci-20.1-b02
}

if [ "${JDK_VERSION}" == "jdk8" ]; then
    jdk8
elif [ "$JDK_VERSION" == "jdk11" ]; then
    jdk11
else
    echo "Need to provide a valid JDK version: jdk8, jdk11"
    exit 1
fi

mkdir graal
cd graal
export PATH=$PWD/mx:$PATH

git clone --depth=1 https://github.com/oracle/graal
git clone --depth=1 https://github.com/graalvm/mx

cd graal/vm
echo "Git commit: `git rev-parse HEAD`"
mx clean
mx --disable-polyglot --disable-libpolyglot --dynamicimports /substratevm --skip-libraries=true build

# Copy Graal SDK to new directory defined as artifact/cache
echo "Copying Graal SDK to ${CI_PROJECT_DIR}/graal_dist..."
cp -R $CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home/ $CI_PROJECT_DIR/graal_dist
