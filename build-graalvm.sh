#!/bin/bash

JDK_VERSION=$1
GRAALVM_BRANCH="release/graal-vm/21.0"

downloadJdk() {
    JAVA_VERSION=$1
    cd ${GRAALVM_DIR}/graal
    export JAVA_HOME=`yes | mx fetch-jdk --to ${CI_PROJECT_DIR} --java-distribution ${JAVA_VERSION} | tail -1 | sed 's/export JAVA_HOME=//'`
}

mkdir graal
cd graal
export GRAALVM_DIR=`pwd`
export PATH=$PWD/mx:$PATH

git clone --branch ${GRAALVM_BRANCH} https://github.com/oracle/graal
git clone --branch ${GRAALVM_BRANCH} https://github.com/graalvm/graaljs
git clone --depth=1 https://github.com/graalvm/mx

if [ "${JDK_VERSION}" == "jdk8" ]; then
    downloadJdk openjdk8
elif [ "$JDK_VERSION" == "jdk11" ]; then
    downloadJdk labsjdk-ce-11
else
    echo "Need to provide a valid JDK version: jdk8, jdk11"
    exit 1
fi

echo "------------------------------------"
echo "GraalVM branch: ${GRAALVM_BRANCH}"
${JAVA_HOME}/bin/java -version
echo "------------------------------------"

cd ${GRAALVM_DIR}/graaljs/graal-js
echo "------------------------------------"
echo "Building Graal-JS"
git log -1
echo "------------------------------------"
mx clean
mx --dynamicimports /compiler build

cd ${GRAALVM_DIR}/graal/vm
echo "------------------------------------"
echo "Building GraalVM"
git log -1
echo "------------------------------------"
mx clean
mx --disable-polyglot --disable-libpolyglot --dynamicimports /substratevm,/graal-js --force-bash-launchers=native-image-configure,gu --skip-libraries=true build

# Copy Graal SDK to new directory defined as artifact/cache
echo "Copying Graal SDK to ${CI_PROJECT_DIR}/graal_dist..."
cp -R ${GRAALVM_DIR}/graal/vm/latest_graalvm_home/ $CI_PROJECT_DIR/graal_dist
