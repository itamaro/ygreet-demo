from __future__ import print_function

import os

import grpc

from proto.protos import service_pb2
from proto.protos import service_pb2_grpc


CPPGREETER_SVC = os.environ.get('CPPGREETER', 'localhost:50051')


def say_hello(name=None):
    channel = grpc.insecure_channel(CPPGREETER_SVC)
    stub = service_pb2_grpc.GreeterStub(channel)
    response = stub.SayHello(service_pb2.HelloRequest(name=name))
    return {
        'pygreeter': 'Hello {}!'.format(name),
        'cppgreeter': response.message,
    }


if __name__ == '__main__':
  print(say_hello('main'))
