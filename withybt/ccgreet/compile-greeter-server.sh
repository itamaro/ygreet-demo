#!/bin/bash

PROTO_DIR="build/proto/protos"
CC_FLAGS="-std=c++11 -I/usr/local/include -Ibuild -pthread"
LINK_FLAGS="-L/usr/local/lib -L/usr/local/lib -lgrpc++ -lgrpc -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed -lprotobuf -lpthread -ldl"

g++ $CC_FLAGS -c -o "$PROTO_DIR/service.pb.o" "$PROTO_DIR/service.pb.cc"
g++ $CC_FLAGS -c -o "$PROTO_DIR/service.grpc.pb.o" "$PROTO_DIR/service.grpc.pb.cc"
g++ $CC_FLAGS -c -o "ccgreet/greeter_server.o" "ccgreet/greeter_server.cc"
mkdir -p "build/ccgreet"
g++ "$PROTO_DIR/service.pb.o" "$PROTO_DIR/service.grpc.pb.o" "ccgreet/greeter_server.o" \
    $LINK_FLAGS -o "build/ccgreet/greeter_server"
