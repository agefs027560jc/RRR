#!/usr/bin/env bash

set -x -e

sudo apt update
sudo apt upgrade -y
sudo apt install -y python2 pkg-config build-essential libboost-all-dev cmake cmake-curses-gui ninja-build


cmake -G Ninja -S. -H. -B ./build
cmake --build ./build

bin/rpcgen sample/demo.rrr

g++ -c -I. -I ./sample sample/demo_impl.cc sample/server.cc
g++ demo_impl.o server.o -o rpc_svc -L. -L ./build -lrrr -lpthread -lboost_coroutine -lboost_context -lboost_system
g++ -c -I. -I ./sample sample/client.cc
g++ client.o -o rpc_clnt -L. -L ./build -lrrr -lpthread -lboost_coroutine -lboost_context -lboost_system
