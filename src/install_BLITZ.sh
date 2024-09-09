#! /bin/bash

rm -rf blitz
git clone --branch 1.0.2 https://github.com/blitzpp/blitz.git
cd blitz
BUILDDIR=build
mkdir -p $BUILDDIR && cd $BUILDDIR
echo "cmake ../. -DCMAKE_INSTALL_PREFIX=$1/BLITZ"
cmake ../. -DCMAKE_INSTALL_PREFIX=$1/BLITZ
make -j $2
make install
