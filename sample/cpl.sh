#!/usr/bin/env bash

cmake -G Ninja -S. -H. -B ./build
cmake --build ./build
