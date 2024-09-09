#! /bin/bash

rm -rf OpenBLAS
git clone --branch v0.3.28 https://github.com/OpenMathLib/OpenBLAS.git
cd OpenBLAS

make -j $2
mkdir $1/OPENBLAS
make PREFIX=$1/OPENBLAS install
