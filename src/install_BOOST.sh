#!/bin/bash

rm -rf boost_1_85_0 boost_1_85_0.tar.gz
wget https://archives.boost.io/release/1.85.0/source/boost_1_85_0.tar.gz
tar -xf boost_1_85_0.tar.gz
cd boost_1_85_0

./bootstrap.sh
./b2 -a -j $2 install --prefix=$1/BOOST
