#!/bin/bash

echo "Building micronaut-graal-experiments..."

export GRAALVM_HOME=$CI_PROJECT_DIR/graal/graal/vm/latest_graalvm_home
export PATH=$GRAALVM_HOME/bin:$PATH
native-image --version

export JAVA_HOME=$CI_PROJECT_DIR/graal/openjdk1.8.0_192-jvmci-0.53
export PATH=$JAVA_HOME/bin:$PATH
java -version

git clone https://github.com/graemerocher/micronaut-graal-experiments.git
cd micronaut-graal-experiments/fresh-graal
./gradlew --no-daemon --console=plain assemble
