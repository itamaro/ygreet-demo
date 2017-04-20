#!/bin/bash

echo "Building builder images"
docker build -t ygreet-builder:latest -f builder/Dockerfile.cpp builder
docker build -t ygreet-pybuild:latest -f builder/Dockerfile.python builder

echo "Making artifacts"
cd app && make && cd ..

echo "Building service images"
docker build -t cppgreet-svc:latest -f app/Dockerfile.cppgreet app
docker build -t pygreet-svc:latest -f app/Dockerfile.pygreet app
