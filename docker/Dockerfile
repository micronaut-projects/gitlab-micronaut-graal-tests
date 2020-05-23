FROM oraclelinux:7-slim

ENV LANG=en_US.UTF-8

RUN yum update -y oraclelinux-release-el7 \
    && yum install -y oraclelinux-developer-release-el7 oracle-softwarecollection-release-el7 \
    && yum-config-manager --enable ol7_developer \
    && yum-config-manager --enable ol7_developer_EPEL \
    && yum-config-manager --enable ol7_optional_latest \
    && yum install -y bzip2-devel ed gcc gcc-c++ gcc-gfortran gzip file fontconfig less libcurl-devel make openssl openssl-devel readline-devel tar vi which xz-devel zlib-devel git \
    && yum install -y glibc-static libcxx libcxx-devel libstdc++-static zlib-static \
    && rm -rf /var/cache/yum

RUN fc-cache -f -v
