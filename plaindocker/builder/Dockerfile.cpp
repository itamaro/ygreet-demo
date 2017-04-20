FROM ubuntu:16.04

ARG GRPC_VERSION="v1.2.4"

RUN apt-get update && \
    apt-get install --no-install-recommends -y git build-essential autoconf automake curl make g++ unzip libtool ca-certificates pkg-config

RUN cd /tmp && \
    git clone -b $GRPC_VERSION https://github.com/grpc/grpc grpc && \
    cd grpc && \
    git submodule update --init && \
    cd third_party/protobuf && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig /usr/local/lib && \
    cd ../.. && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/grpc
