#!/bin/bash
# Cross compiling with configure

TOOLCHAIN_BIN=/androidtmp/android-toolchain_r21/bin
export PATH=$TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=/androidtmp/android-toolchain_r21/sysroot/usr/lib:/androidtmp/android-toolchain_r21/lib64

TARGET_HOST=aarch64-linux-android

export CC=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang
export CXX=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang++
export CXXFLAGS=" -O2 -fPIE -fPIC -static-libstdc++ -fuse-ld=gold "
export CFLAGS=" -O2 -fPIC -fPIE -I$PWD/include -L$PWD/lib"
export LDFLAGS=" -pie "
export PYTHONPATH=$HOME/ndk/android-sdk/ndk/21.0.6113669/python-packages:$PYTHONPATH



PWD=`pwd`
INSTALL_DIR=$PWD/`basename "$PWD" | cut -d'-' -f1 | cut -d'.' -f1`-out

./configure \
	--prefix=$INSTALL_DIR \
	--host=aarch64-linux \

make -j4
make install

