#!/bin/bash

git clone https://github.com/openucx/ucx.git ucx
cd ucx

echo "Installing UCX v1.17.0"
./autogen.sh
mkdir build
cd build
../configure --prefix=$1/UCX
make -j $2
make install
