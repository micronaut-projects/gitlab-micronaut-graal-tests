#!/bin/bash

echo "Building Graal..."

mkdir graal
cd graal

wget -q https://github.com/graalvm/openjdk8-jvmci-builder/releases/download/jvmci-0.59/openjdk-8u202-jvmci-0.59-linux-amd64.tar.gz
tar zxf openjdk-8u202-jvmci-0.59-linux-amd64.tar.gz
export PATH=$PWD/mx:$PATH
export JAVA_HOME=$CI_PROJECT_DIR/graal/openjdk1.8.0_202-jvmci-0.59

git clone https://github.com/oracle/graal
git clone https://github.com/graalvm/mx

cd graal/vm
mx clean
LIBGRAAL=true mx --disable-polyglot --disable-libpolyglot --dynamicimports /substratevm build
