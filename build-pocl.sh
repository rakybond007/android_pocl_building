#!/bin/bash
PWD=`pwd`
I_AM=`id -un`
MY_GROUP=`id -gn`
ANDROID_NDK=$HOME/toolchains/android-ndk-r21
ANDROID_TOOLCHAIN=/androidtmp2/android-toolchain_r21
ANDROID_TOOLCHAIN_BIN=/androidtmp2/android-toolchain_r21/bin
ANDROID_TOOLCHAIN_SYSROOT_USR=$ANDROID_TOOLCHAIN/sysroot/usr
ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB=$ANDROID_TOOLCHAIN/sysroot/usr/lib/aarch64-linux-android

echo "NDK standalone toolchain setup..."
$ANDROID_NDK/build/tools/make_standalone_toolchain.py \
	--arch arm64 \
	--api 28 \
	--install-dir=$ANDROID_TOOLCHAIN \
	--force

INSTALL_PREFIX=/data/data/org.pocl.libs/files/
# Create directories for PREFIX, target location in android
if [ ! -e $INSTALL_PREFIX ]; then
	sudo mkdir -p $INSTALL_PREFIX
	sudo mkdir -p $INSTALL_PREFIX/lib/pkgconfig/
	sudo chown -R $I_AM:$MY_GROUP $INSTALL_PREFIX
	sudo chmod 755 -R $INSTALL_PREFIX
fi

# Prebuilt llvm lib that run on(android) -> target(android)
# Prebuilt llvm bin that run on(x64) -> target(android)
echo "copying llvm to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf /home/hj/data/llvm/* $ANDROID_TOOLCHAIN_SYSROOT_USR


echo "copying ncurses to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf /home/hj/data/ncurses/ncurses-out/* $ANDROID_TOOLCHAIN_SYSROOT_USR
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_USR/lib/libncurses.a $ANDROID_TOOLCHAIN_SYSROOT_USR/lib/libcurses.a


echo "copying ltdl to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf /home/hj/data/libtool/libtool-out/* $ANDROID_TOOLCHAIN_SYSROOT_USR


echo "copying hwloc to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
cp -rf /home/hj/data/hwloc/hwloc-out/* $ANDROID_TOOLCHAIN_SYSROOT_USR


#echo "copying ld to $ANDROID_TOOLCHAIN_SYSROOT_USR ..."
#cp -rf $POCL_DEPENDENCY/binutils/* $ANDROID_TOOLCHAIN_SYSROOT_USR


ln -sf $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libc.a $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libpthread.a
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libc.a $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/librt.a
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libc.a $ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB/libtinfo.a
ln -sf $ANDROID_TOOLCHAIN_SYSROOT_USR/include/GLES3 $ANDROID_TOOLCHAIN_SYSROOT_USR/include/GL

ln -sf $ANDROID_TOOLCHAIN_BIN/28-clang $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/clang
ln -sf $ANDROID_TOOLCHAIN_BIN/28-clang++ $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/clang++
ln -sf $ANDROID_TOOLCHAIN_BIN/llvm-as $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/
ln -sf $ANDROID_TOOLCHAIN_BIN/llvm-link $ANDROID_TOOLCHAIN_SYSROOT_USR/bin/

export PATH=$ANDROID_TOOLCHAIN_SYSROOT_USR/bin:$ANDROID_TOOLCHAIN_BIN:$PATH
export LD_LIBRARY_PATH=$ANDROID_TOOLCHAIN_SYSROOT_USR/lib:$ANDROID_TOOLCHAIN_SYSROOT_AARCH64_LIB:$LD_LIBRARY_PATH
export HOST=aarch64-linux-android
export TARGET_CPU="cortex-a55"
export CC=$ANDROID_TOOLCHAIN_BIN/$HOST\28-clang
export CXX=$ANDROID_TOOLCHAIN_BIN/$HOST\28-clang++
export AR=$ANDROID_TOOLCHAIN_BIN/$HOST-ar
export RANLIB=$ANDROID_TOOLCHAIN_BIN/$HOST-ranlib
export LDFLAGS=" -pie "
export PYTHONPATH=$HOME/toolchains/android-ndk-r21/python-packages:$PYTHONPATH


cmake \
	-DCMAKE_TOOLCHAIN_FILE=android.cmake \
	-DANDROID_ABI="arm64-v8a" \
	-DANDROID_PLATFORM="28" \
	-DCMAKE_C_COMPILER=$CC \
	-DCMAKE_CXX_COMPILER=$CXX \
	-DCMAKE_BUILD_TYPE:STRING=Release \
	-DCMAKE_AR:FILEPATH=$HOST-ar \
	-DCMAKE_RANLIB:FILEPATH=$HOST-ranlib \
	-DCMAKE_CXX_FLAGS:STRING="-Os -fPIE -fPIC -static-libstdc++ -fuse-ld=gold -ffunction-sections -fdata-sections -fno-lto" \
	-DCMAKE_C_FLAGS:STRING="-Os -fPIE -fPIC -ffunction-sections -fdata-sections -fno-lto" \
	-DCMAKE_EXE_LINKER_FLAGS:STRING='-fno-lto -fuse-linker-plugin -Wl,--gc-sections' \
	-DCMAKE_MODULE_LINKER_FLAGS:STRING='-fno-lto -fuse-linker-plugin -Wl,--gc-sections'  \
	-DCMAKE_SHARED_LINKER_FLAGS:STRING='-fno-lto -fuse-linker-plugin -Wl,--gc-sections' \
	-DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
	-DLLC_HOST_CPU=$TARGET_CPU \
	..
