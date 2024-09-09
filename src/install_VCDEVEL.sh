#! /bin/bash

rm -rf Vc
git clone --branch 1.4.5 https://github.com/VcDevel/Vc.git
cd Vc
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$1/VCDEVEL ..
make -j $2 install

