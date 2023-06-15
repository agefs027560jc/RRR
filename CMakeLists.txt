cmake_minimum_required(VERSION 3.5)

set(CMAKE_CXX_COMPILER g++)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED YES)

project(rrr)

find_package(Threads)
find_package(PkgConfig REQUIRED)
pkg_check_modules(PYTHON REQUIRED python3)

set(CMAKE_VERBOSE_MAKEFILE on)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -DNDEBUG")

#if(APPLE)
#  set(RT "")
#else()
#  set(RT "rt")
#endif()

include_directories(
  ${PYTHON_INCLUDE_DIRS}
  ${CMAKE_CURRENT_SOURCE_DIR}
)

link_directories(
  ${PYTHON_LIBRARY_DIRS}
)

file(GLOB src
  "base/*.hpp"
  "base/*.cpp"
  "misc/*.hpp"
  "misc/*.cpp"
#  "mq/*.cpp"
#  "mq/*.h"
  "reactor/*.h"
  "reactor/*.cc"
  "pylib/simplerpc/_pyrpc.cpp"
  "rpc/*.cpp"
  "rpc/*.hpp"
  "utils/*.h"
  "rrr.h"
  "rrr.hpp"
)

add_library(rrr
    ${src})
