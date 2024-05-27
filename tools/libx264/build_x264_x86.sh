#!/bin/sh

# 编译选项
EXTRA_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"

# x264 源码目录
X264_SOURCE=${ROOT_SOURCE}/build/x264
# 输出路径
PREFIX=${X264_SOURCE}/android/x86

# 配置和编译
cd ${X264_SOURCE}
./configure \
--prefix=${PREFIX} \
--enable-static \
--enable-pic \
--enable-strip \
--host=i686-linux-android \
--cross-prefix=${TOOLCHAIN}/bin/i686-linux-android- \
--sysroot=${PLATFORM} \
--extra-cflags="-Os -fPIC ${EXTRA_CFLAGS}" \
--extra-ldflags="" \
${ADDITIONAL_CONFIGURE_FLAG}

make clean
make -j4
make install
