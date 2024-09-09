#! /bin/bash

rm -rf zlib
git clone https://github.com/madler/zlib.git
cd zlib

./configure --prefix=$1/ZLIB
make -j $2
make check install
cd ..
