#! /bin/bash

if [ -d "$1/MPI" ]; then
  mpi_dir="$1/MPI"
else
  mpi_dir=$(dirname "$(dirname "$(which mpic++)")")
fi

git clone -b release https://gitlab.com/petsc/petsc.git petsc
cd petsc
git checkout v3.21.5
configure_options="--with-64-bit-indices --with-parmetis-include=$1/PARMETIS/include --with-parmetis-lib=$1/PARMETIS/lib/libparmetis.so"
configure_options="$configure_options --with-metis-include=$1/METIS/include --with-metis-lib=[$1/METIS/lib/libmetis.so,$1/METIS/lib/libGKlib.a]"

configure_options="$configure_options --with-blaslapack-dir=$1/OPENBLAS"
#configure_options="$configure_options --with-suitesparse-include=$1/SUITESPARSE/include --with-suitesparse-lib=\"-L$1/SUITESPARSE/lib -lsuitesparse -lopenblas \"" 
configure_options="$configure_options --download-scalapack --download-mumps --download-superlu_dist --download-hypre --download-scalapack"

echo "Installing PETSC with options $configure_options"

export DYLD_LIBRARY_PATH='$DYLD_LIBRARY_PATH:$1/METIS/lib/:$1/SUITESPARSE/lib/:$1/OPENBLAS/lib'
export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:$1/METIS/lib/:$1/SUITESPARSE/lib/:$1/OPENBLAS/lib'
python ./configure COPTFLAGS="-O3 -g" CXXOPTFLAGS="-O3 -g" FOPTFLAGS="-O3 -g" $ldflags_petsc  --with-cxx-dialect=C++11 $petsc_openmp --with-mpi-dir=$mpi_dir $configure_options --prefix=$1/PETSC --with-debugging=0

make all -j $2

make install
