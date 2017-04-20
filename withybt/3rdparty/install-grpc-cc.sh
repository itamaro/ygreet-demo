#!/bin/bash

set -e
curl https://codeload.github.com/google/boringssl/tar.gz/78684e5b222645828ca302e56b40b9daff2b2d27 | tar zxf - -C /tmp
mv /tmp/boringssl-78684e5b222645828ca302e56b40b9daff2b2d27/* grpc-1.2.4/third_party/boringssl
cd grpc-1.2.4
make
make install
ldconfig /usr/local/lib
