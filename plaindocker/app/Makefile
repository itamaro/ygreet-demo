
BUILDER_IMAGE = ygreet-builder:latest
PYBUILD_IMAGE = ygreet-pybuild:latest
DFLAG = -it --rm -v `pwd`/$(PROTOS_PATH):/protos -v `pwd`:/code -w /code
DRUN = docker run $(DFLAG) $(BUILDER_IMAGE)
PYRUN = docker run $(DFLAG) $(PYBUILD_IMAGE)
CXX = $(DRUN) g++
CPPFLAGS += -I/usr/local/include -pthread
CXXFLAGS += -std=c++11
LDFLAGS += -L/usr/local/lib -L/usr/local/lib -lgrpc++ -lgrpc      \
           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
           -lprotobuf -lpthread -ldl
GOPATH = /root/go
PROTOC = $(DRUN) protoc
PYPROTO = $(PYRUN)
GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH = /usr/local/bin/grpc_cpp_plugin

PROTOS_PATH = ../protos
DOCKER_PROTOS_PATH = /protos

vpath %.proto $(PROTOS_PATH)

all: greeter_server service_pb2.py

greeter_server: service.pb.o service.grpc.pb.o greeter_server.o
	$(CXX) $^ $(LDFLAGS) -o $@

.PRECIOUS: %.grpc.pb.cc
%.grpc.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

.PRECIOUS: %.pb.cc
%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

.PRECIOUS: %_pb2.py
%_pb2.py: %.proto
	$(PYPROTO) -I $(PROTOS_PATH) --python_out=. --grpc_python_out=. $<

clean:
	rm -f *.o *.pb.cc *.pb.h *_pb2* greeter_server
