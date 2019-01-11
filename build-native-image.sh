#!/bin/bash

PROJECT_DIR=$1

native-image --no-server \
             --allow-incomplete-classpath -cp $PROJECT_DIR/build/libs/fresh-graal-0.1-all.jar \
             -H:ReflectionConfigurationFiles=$PROJECT_DIR/reflect.json \
             -H:EnableURLProtocols=http \
             -H:IncludeResources="logback.xml|application.yml" \
             -H:Name=fresh-graal \
             -H:Class=fresh.graal.Application \
             -H:+ReportUnsupportedElementsAtRuntime \
             -H:+AllowVMInspection \
             --rerun-class-initialization-at-runtime='sun.security.jca.JCAUtil$CachedSecureRandomHolder,javax.net.ssl.SSLContext' \
             --delay-class-initialization-to-runtime=io.netty.handler.codec.http.HttpObjectEncoder,io.netty.handler.codec.http.websocketx.WebSocket00FrameEncoder,io.netty.handler.ssl.util.ThreadLocalInsecureRandom,com.sun.jndi.dns.DnsClient