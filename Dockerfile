FROM debian:bookworm-slim

RUN apt update && apt install -y sudo

RUN adduser --disabled-password \
--gecos '' docker

RUN adduser docker sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

USER docker

RUN sudo apt update && sudo apt install -y git cmake build-essential gfortran bzip2 libbz2-dev python-dev-is-python3 wget

ENV CC=gcc   
ENV CXX=g++   
ENV F77=gfortran   
ENV FC=gfortran   
ENV PREFIX_DEPENDS=/home/docker/ofp_dep   
ENV PREFIX_OPENFPM=/home/docker/ofp_install   
ENV NCORE=$(nproc)   
ENV GPU_CUDA_SUPPORT=0

WORKDIR /home/docker/

RUN git clone --recursive https://github.com/abhinavsns/openfpm.git

RUN mkdir /home/docker/openfpm/build

RUN mkdir /home/docker/dep_src

WORKDIR /home/docker/dep_src

RUN ../openfpm/script/install_MPI.sh $PREFIX_DEPENDS $NCORE $GPU_CUDA_SUPPORT $CC $CXX $F77 $FC "--with-mpivendor=openmpi"

ENV PATH=$PREFIX_DEPENDS/MPI/bin:$PATH

RUN ../openfpm/script/install_Metis.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm/script/install_Parmetis.sh $PREFIX_DEPENDS $NCORE mpicc mpic++ $F77 $FC

RUN ../openfpm/script/install_BOOST.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm/script/install_ZLIB.sh $PREFIX_DEPENDS $NCORE mpicc mpic++ $F77 $FC

RUN ../openfpm/script/install_HDF5.sh $PREFIX_DEPENDS $NCORE mpicc mpic++ $F77 $FC

RUN ../openfpm/script/install_LIBHILBERT.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm/script/install_VCDEVEL.sh $PREFIX_DEPENDS $NCORE $CC $CXX

RUN ../openfpm/script/install_OPENBLAS.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm/script/install_SUITESPARSE.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC $GPU_CUDA_SUPPORT

RUN ../openfpm/script/install_EIGEN.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm/script/install_BLITZ.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm//script/install_ALGOIM.sh $PREFIX_DEPENDS $NCORE $CC $CXX $F77 $FC

RUN ../openfpm/script/install_MINTER.sh $PREFIX_DEPENDS

#./script/install_PETSC.sh $PREFIX_DEPENDS $NCORE mpicc mpic++ $F77 $FC $GPU_CUDA_SUPPORT 87
# where the last parameter is cuda arch that could be determined with nvcc --list-gpu-arch
# otherwise
#RUN ../openfpm/script/install_PETSC.sh $PREFIX_DEPENDS $NCORE mpicc mpic++ $F77 $FC $GPU_CUDA_SUPPORT
RUN wget -O install_PETSC.sh https://raw.githubusercontent.com/abhinavsns/openfpm-superbuild/refs/heads/main/src/install_PETSC.sh
RUN chmod +x install_PETSC.sh
RUN ./install_PETSC.sh $PREFIX_DEPENDS $NCORE

WORKDIR /home/docker/openfpm/build

ENV LD_LIBRARY_PATH=/home/docker/ofp_dep/METIS/lib/

RUN cmake .. -DCMAKE_INSTALL_PREFIX=/home/docker/ofp_install  -DCMAKE_BUILD_TYPE=  -DSE_CLASS1=OFF  -DSE_CLASS2=OFF  -DSE_CLASS3=OFF  -DTEST_COVERAGE=OFF  -DSCAN_COVERTY=OFF  -DTEST_PERFORMANCE=OFF  -DENABLE_ASAN=OFF  -DENABLE_NUMERICS=ON  -DENABLE_GARBAGE_INJECTOR=OFF  -DENABLE_VCLUSTER_GARBAGE_INJECTOR=OFF  -DCUDA_ON_BACKEND=NONE  -DMPI_VENDOR=openmpi  -DMPI_ROOT=/home/docker/ofp_dep/MPI  -DPETSC_ROOT=/home/docker/ofp_dep/PETSC  -DBOOST_ROOT=/home/docker/ofp_dep/BOOST -DBoost_NO_BOOST_CMAKE=ON  -DHDF5_ROOT=/home/docker/ofp_dep/HDF5/  -DLIBHILBERT_ROOT=/home/docker/ofp_dep/LIBHILBERT  -DBLITZ_ROOT=/home/docker/ofp_dep/BLITZ  -DALGOIM_ROOT=/home/docker/ofp_dep/ALGOIM  -DPARMETIS_ROOT=/home/docker/ofp_dep/PARMETIS  -DMETIS_ROOT=/home/docker/ofp_dep/METIS  -DVc_ROOT=/home/docker/ofp_dep/VCDEVEL  -DOPENBLAS_ROOT=/home/docker/ofp_dep/OPENBLAS/ -DBLAS_ROOT=/home/docker/ofp_dep/OPENBLAS/ -DEIGEN3_ROOT=/home/docker/ofp_dep/EIGEN  -DMINTER_ROOT=/home/docker/ofp_dep/MINTER -DSUITESPARSE_ROOT=/home/docker/ofp_dep/SUITESPARSE

RUN make -j $NCORE install

WORKDIR /home/docker/

RUN ./openfpm/script/create_env_vars.sh $PREFIX_DEPENDS $PREFIX_OPENFPM
RUN ./openfpm/script/create_example.mk.sh $PREFIX_DEPENDS $PREFIX_OPENFPM






