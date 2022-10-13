#!/bin/bash
echo "Please type project name: "
read NAME

cd $(dirname $0)
cd ../

if test -e "$NAME"; then
    echo "ERROR: The project $NAME exist!"
    exit 0
fi
mkdir $NAME

cd ./$NAME
mkdir csrc
cp ../init/sim/sim_main.cpp ./csrc
cp ../init/sim/input.vc ./csrc

mkdir vsrc
touch ./vsrc/top.v

mkdir sim
cp ../init/sim/Makefile ./sim

mkdir fpga
cp -r ../init/fpga ./
