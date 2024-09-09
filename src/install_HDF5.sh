#! /bin/bash

rm -rf hdf5_1.14.4.3 hdf5_1.14.4.3
wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5_1.14.4.3.tar.gz
tar -xf hdf5_1.14.4.3.tar.gz
cd hdf5-hdf5_1.14.4.3

CC=mpicc ./configure --with-zlib=$1/ZLIB --enable-parallel --prefix=$1/HDF5
make -j $2

mkdir $1/HDF5
make install
