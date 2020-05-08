#!/bin/bash
# Scripts for building llvm

INSTALL_DIR=$HOME/data/llvm_arm64-out/
[ ! -d "$INSTALL_DIR" ] && mkdir $INSTALL_DIR
TOOLCHAIN_PATH=/androidtmp/android-toolchain_r21
TOOLCHAIN_BIN=$TOOLCHAIN_PATH/bin
SYSROOT=$TOOLCHAIN_PATH/sysroot
#ARM_LIB_PATH=$HOME/android_pocl/pocl/pocl-android-dependency/Libs_ARM64


export PATH=$TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=$SYSROOT/usr/lib:$TOOLCHAIN_PATH/lib64:$LD_LIBRARY_PATH
TARGET_HOST=aarch64-linux-android

export CC=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang
export CXX=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang++
export AS=$TOOLCHAIN_BIN/$TARGET_HOST\28-clang
export AR=$TOOLCHAIN_BIN/$TARGET_HOST-ar
export RANLIB=$TOOLCHAIN_BIN/$TARGET_HOST-ranlib
export LD=$TOOLCHAIN_BIN/$TARGET_HOST-ld
export STRIP=$TOOLCHAIN_BIN/$TARGET_HOST-strip
export CXXFLAGS=" -funwind-tables -O2 -fPIE -fPIC -static-libstdc++ -fuse-ld=gold -Wno-error=unused-command-line-argument "
export CFLAGS=" -O2 -fPIC -fPIE -Wno-error=unused-command-line-argument "
export LDFLAGS=" -pie "
export PYTHONPATH=$HOME/ndk/android-sdk/ndk/21.0.6113669/python-packages:$PYTHONPATH 

PYTHON_EXECUTABLE=$TOOLCHAIN_BIN/python #for android 

cmake -G "Unix Makefiles" \
	-DCMAKE_CROSSCOMPILING=True \
	-DLLVM_TARGET_ARCH=AArch64 \
	-DLLVM_ENABLE_PROJECTS="clang;llvm" \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=$CC \
	-DCMAKE_CXX_COMPILER=$CXX \
	-DLLVM_TARGETS_TO_BUILD="AArch64" \
	-DLLVM_DEFAULT_TARGET_TRIPLE=$TARGET_HOST \
	-DLLVM_ENABLE_DIA_SDK=OFF \
	-DLLVM_TABLEGEN=/home/hj/data/llvm-project/build_x86_real/bin/llvm-tblgen \
	-DCLANG_TABLEGEN=/home/hj/data/llvm-project/build_x86_real/bin/clang-tblgen \
	-DLIBCLANG_BUILD_STATIC=ON \
	../llvm

make -j4

make install

