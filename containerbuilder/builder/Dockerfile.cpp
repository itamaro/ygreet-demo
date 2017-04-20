FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential autoconf automake curl make g++ unzip libtool ca-certificates pkg-config

COPY grpc /tmp/grpc

RUN cd /tmp/grpc/third_party/protobuf && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig /usr/local/lib && \
    cd ../.. && \
    make && \
    make install && \
    cd / && rm -rf /tmp/grpc
