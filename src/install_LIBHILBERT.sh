#! /bin/bash

rm -rf libhilbert 
git clone https://github.com/abhinavsns/libhilbert
cd libhilbert

mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=$1/LIBHILBERT ..
make -j$2 install

