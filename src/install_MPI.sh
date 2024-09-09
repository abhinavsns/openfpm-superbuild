#!/bin/bash

rm -rf ompi
git clone --recursive https://github.com/open-mpi/ompi.git
cd ompi
./autogen.pl

mkdir build
cd build
../configure --prefix=$1/MPI --with-ucx=$1/UCX
#--enable-mca-no-build=btl-uct
make -j $2
make install
