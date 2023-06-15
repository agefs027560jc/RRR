#!/usr/bin/env bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y python2 build-essential libboost-all-dev cmake cmake-curses-gui ninja-build

cmake -G Ninja -S. -H. -B ./build
cmake --build ./build
