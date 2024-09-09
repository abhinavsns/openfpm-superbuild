#! /bin/bash

rm -rf algoim
git clone https://github.com/algoim/algoim.git
mkdir -p $1/ALGOIM
mv algoim/algoim $1/ALGOIM/include
