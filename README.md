# android_pocl_building
Reference : https://github.com/FreemanX/pocl-android-dependency.git
*** PATHs like INSTALL_DIR is not automated!! Current values are customized for me, so you have to change every script ***

I got lot of help in above github, you can refer the issue.

1. You can Download ndk from https://ci.android.com/builds/branches/aosp-ndk-release-r21/grid? which version is r21!
   (We use toolchain from ndk for cross-compile, every PATH in build script should be modified.) My target is Galaxy S10, android api level 28

2. LLVM-project git link & commit version
    https://android.googlesource.com/toolchain/llvm-project clone from this link, my commit version is 207d7abc1a2abf3ef8d4301736d6a7ebc224a290 (Checkout to there) *You can check the version with /PATH_TO_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang --version.
    We will build clang and llvm from here.
    We have to build llvm for both Host and Target! (X86_64 and aarch64)
    build executable binaries for x86 and copy those files to llvm/bin/
    build static libraries for aarch64 and put them in llvm/lib/
    
3. hwloc https://github.com/open-mpi/hwloc git clone from here, you have to appy the patch. But under v1.9 of hwloc have the src directory to appy the patch file, I checked out to v1.9. And I remember as there is no original configure file, so I remember as I used autogen.sh file.
output dir is named as hwloc-out

4. libtool just followed reference
git clone git://git.savannah.gnu.org/libtool.git  commit b9b44533fbf7c7752ffd255c3d09cc360e24183b
output dir is named as libtool-out

5. ncurses
Found the github https://github.com/mirror/ncurses reference says it's version is 6.2 I used the master.
output dir is named as ncurses-out

6. binutil : Reference repo says to  git clone https://android.googlesource.com/toolchain/binutils
build ld with android ndk, but I got a fail with build script in the binutils repo, lack of python module. I cannot find them in my ndk, but can be found on https://android.googlesource.com/platform/ndk. But I did not tried more

7. Final Target PoCL
We will use binaries and libraries built from above!! LLVM binaries should be Host's and library shoud be Target's. Check the script file and change PATHs! (I think some paths or linking makes error, because I am not skillful on such build process with CMAKE yet...)
https://github.com/pocl/pocl and I used in here ver 1.3. Because in there, you can find some hint of android, which developer tried to. But it seems to be 32bit android...
