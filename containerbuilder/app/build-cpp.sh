#!/bin/bash

CC_FLAGS="-std=c++11 -I/usr/local/include -Ibuild -pthread"
LINK_FLAGS="-L/usr/local/lib -L/usr/local/lib -lgrpc++ -lgrpc -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed -lprotobuf -lpthread -ldl"

protoc -I. --cpp_out=. "service.proto"
protoc -I. --grpc_out=. --plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin "service.proto"
g++ $CC_FLAGS -c -o "service.pb.o" "service.pb.cc"
g++ $CC_FLAGS -c -o "service.grpc.pb.o" "service.grpc.pb.cc"
g++ $CC_FLAGS -c -o "greeter_server.o" "greeter_server.cc"
g++ "service.pb.o" "service.grpc.pb.o" "greeter_server.o" \
    $LINK_FLAGS -o "greeter_server"
