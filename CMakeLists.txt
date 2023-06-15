cmake_minimum_required(VERSION 3.5)

set(CMAKE_CXX_COMPILER g++)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED YES)

project(rrr)

find_package(Threads)
find_package(PkgConfig REQUIRED)
pkg_check_modules(PYTHON REQUIRED python2)

set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "/.../boost")
set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "/.../boost/lib")
set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_NO_BOOST_CMAKE ON)
find_package(Boost COMPONENTS system filesystem context thread coroutine REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

set(CMAKE_VERBOSE_MAKEFILE on)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

#if(APPLE)
#  set(RT "")
#else()
#  set(RT "rt")
#endif()

file(GLOB src
  "base/*.hpp"
  "base/*.cpp"
  "misc/*.hpp"
  "misc/*.cpp"
  "mq/*.cpp"
  "mq/*.h"
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
