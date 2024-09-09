#! /bin/bash

rm -rf SuiteSparse
git clone --branch v7.8.2 https://github.com/DrTimothyAldenDavis/SuiteSparse.git
cd SuiteSparse

mkdir -p build && cd build
cmake -DCMAKE_PREFIX_PATH=$1/OPENBLAS -DCMAKE_INSTALL_PREFIX=$1/SUITESPARSE -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DSUITESPARSE_ENABLE_PROJECTS="suitesparse_config;mongoose;amd;btf;camd;ccolamd;colamd;cholmod;cxsparse;ldl;klu;umfpack;paru;rbio;spqr;graphblas;lagraph" ..
cmake --build . -j $2
cmake --install .




