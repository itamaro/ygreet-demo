#!/bin/bash

set -e
cd protobuf-3.2.0/
./autogen.sh
./configure
make
make check
make install
ldconfig /usr/local/lib
