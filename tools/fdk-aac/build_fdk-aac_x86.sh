#!/bin/bash

SYSROOT=$NDK/platforms/$ANDROID_API/arch-x86

ANDROID_BIN=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64/bin

CROSS_COMPILE=${ANDROID_BIN}/i686-linux-android-

# fdk-aac 源码目录
FDK_AAC_SOURCE=${ROOT_SOURCE}/build/fdk-aac
# 输出路径
PREFIX=${FDK_AAC_SOURCE}/android/x86

CFLAGS=""

FLAGS="--enable-static  --host=i686-linux-android --target=android --disable-asm "

export CXX="${CROSS_COMPILE}g++ --sysroot=${SYSROOT}"

export LDFLAGS=" -L$SYSROOT/usr/lib  $CFLAGS "

export CXXFLAGS=$CFLAGS

export CFLAGS=$CFLAGS

export CC="${CROSS_COMPILE}gcc --sysroot=${SYSROOT}"

export AR="${CROSS_COMPILE}ar"

export LD="${CROSS_COMPILE}ld"

export AS="${CROSS_COMPILE}gcc"

cd ${FDK_AAC_SOURCE}
./configure $FLAGS \
--enable-pic \
--enable-strip \
--prefix=${PREFIX}

$ADDITIONAL_CONFIGURE_FLAG
make clean
make -j4
make install
