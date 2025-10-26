#! /bin/bash
rm -rf GKlib
git clone https://github.com/KarypisLab/GKlib.git
cd GKlib
make distclean
make config shared=1 cc=gcc prefix=$1/METIS
make -j$2 install

cd ..


rm -rf METIS
git clone https://github.com/KarypisLab/METIS.git
cd METIS
make distclean
perl -ni.old -e 'print;if ($.==9) {print "target_link_libraries(metis -lGKlib)\n"}' libmetis/CMakeLists.txt
if [ ! -f $1/METIS/lib/libGKlib.so  ]; then
	if [ -f $1/METIS/lib/libGKlib.so.0  ]; then
		ln -s $1/METIS/lib/libGKlib.so.0  $1/METIS/lib/libGKlib.so
	fi
fi
make config shared=1 cc=gcc prefix=$1/METIS i64=1 r64=1 gklib_path=$1/GKlib
make -j$2 install

# Mark the installation
echo 3 > $1/METIS/version

cd ..

rm -rf ParMETIS
git clone https://github.com/KarypisLab/ParMETIS.git
cd ParMETIS

make config shared=1 cc=$1/MPI/bin/mpicc prefix=$1/PARMETIS metis_path=$1/METIS
make -j$2 install
