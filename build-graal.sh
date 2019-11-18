#!/bin/bash

echo "Building Graal..."

mkdir graal
cd graal

wget -q https://github.com/graalvm/openjdk8-jvmci-builder/releases/download/jvmci-19.3-b04/openjdk-8u232-jvmci-19.3-b04-linux-amd64.tar.gz
tar zxf openjdk-8u232-jvmci-19.3-b04-linux-amd64.tar.gz
export PATH=$PWD/mx:$PATH
export JAVA_HOME=$CI_PROJECT_DIR/graal/openjdk1.8.0_232-jvmci-19.3-b04

git clone --depth=1 https://github.com/oracle/graal
git clone --depth=1 https://github.com/graalvm/mx

cd graal/vm
echo "Git commit: `git rev-parse HEAD`"
mx clean
mx --disable-polyglot --disable-libpolyglot --dynamicimports /substratevm --skip-libraries=true build

# Copy Graal SDK to new directory defined as artifact/cache
echo "Copying Graal SDK to ${$CI_PROJECT_DIR}/graal_dist..."
cp -R $CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home/ $CI_PROJECT_DIR/graal_dist
