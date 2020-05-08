#!/bin/bash
# Cross compiling with configure

TOOLCHAIN_BIN=/androidtmp/android-toolchain_r21/bin
export PATH=$TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=/androidtmp/android-toolchain_r21/sysroot/usr/lib:/androidtmp/android-toolchain_r21/lib64
TARGET_HOST=aarch64-linux-android

export CC=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang
export CXX=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang++
#export STRIP=$TOOLCHAIN_BIN/$TARGET_HOST-strip
#export LD=$target_host-ld
#export AR=$target_host-ar
export CXXFLAGS=" -O2 -fPIE -fPIC -static-libstdc++ -fuse-ld=gold "
export CFLAGS=" -O2 -fPIC -fPIE -I$PWD/include -L$PWD/lib"
export LDFLAGS=" -pie "

#alias install="install --strip-program=$STRIP "


PWD=`pwd`
INSTALL_DIR=$PWD/`basename "$PWD"`-out

./configure \
	--prefix=$INSTALL_DIR \
	--host=aarch64-linux \
	--without-cxx \
	--without-cxx-binding \
	--disable-db-install \
	--without-progs \
	--without-manpages

make -j4
make install

