#!/bin/sh

#编译目录
BUILD_SOURCE=${ROOT_SOURCE}/build
#FFmpeg的源码目录
FFMPEG_SOURCE=${BUILD_SOURCE}/ffmpeg

# x264的目录
X264_INCLUDE=${BUILD_SOURCE}/x264/android/x86/include
X264_LIB=${BUILD_SOURCE}/x264/android/x86/lib

# fdk-aac的目录
FDK_AAC_INCLUDE=${BUILD_SOURCE}/fdk-aac/android/x86/include
FDK_AAC_LIB=${BUILD_SOURCE}/fdk-aac/android/x86/lib

# x86
CPU=x86
OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32 "
ADDI_CFLAGS="-mi686"
PREFIX=${FFMPEG_SOURCE}/android/${CPU}

cd $FFMPEG_SOURCE

# 移除旧的文件夹
rm -rf ${PREFIX}
# 重新创建新的文件夹
mkdir -p ${PREFIX}

# 配置
./configure \
--prefix=${PREFIX} \
--arch=x86 \
--cpu=x86 \
--target-os=android \
--enable-cross-compile \
--cross-prefix=${TOOLCHAIN}/bin/i686-linux-android- \
--sysroot=${PLATFORM} \
--extra-cflags="-I${X264_INCLUDE} -I${FDK_AAC_INCLUDE} -I${PLATFORM}/usr/include" \
--extra-ldflags="-L${X264_LIB} -L${FDK_AAC_LIB}" \
--cc=${TOOLCHAIN}/bin/i686-linux-android-gcc \
--nm=${TOOLCHAIN}/bin/i686-linux-android-nm \
--disable-shared \
--enable-nonfree \
--enable-static \
--enable-gpl \
--enable-version3 \
--enable-pthreads \
--enable-runtime-cpudetect \
--enable-small \
--disable-network \
--disable-iconv \
--disable-x86asm \
--enable-neon \
--disable-yasm \
--enable-pic \
--disable-encoders \
--enable-libx264 \
--enable-libfdk_aac \
--enable-encoder=libx264 \
--enable-encoder=libfdk_aac \
--enable-encoder=aac \
--enable-encoder=mpeg4 \
--enable-encoder=mjpeg \
--enable-encoder=pcm_s16le \
--enable-encoder=pcm_alaw \
--enable-encoder=pcm_ulaw \
--disable-muxers \
--enable-muxer=avi \
--enable-muxer=dts \
--enable-muxer=h264 \
--enable-muxer=mp3 \
--enable-muxer=mp4 \
--enable-muxer=mov \
--enable-muxer=mpegts \
--disable-decoders \
--enable-jni \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-hwaccel=h264_mediacodec \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=mp3 \
--enable-decoder=h264 \
--enable-decoder=mpeg4 \
--enable-decoder=mjpeg \
--disable-demuxers \
--enable-demuxer=avi \
--enable-demuxer=h264 \
--enable-demuxer=aac \
--enable-demuxer=dts \
--enable-demuxer=mp3 \
--enable-demuxer=mov \
--enable-demuxer=m4v \
--enable-demuxer=mpegts \
--enable-demuxer=mjpeg \
--enable-demuxer=mpegvideo \
--enable-demuxer=rawvideo \
--disable-parsers \
--enable-parser=aac \
--enable-parser=ac3 \
--enable-parser=h264 \
--enable-parser=mjpeg \
--enable-parser=mpegvideo \
--enable-parser=mpegaudio \
--disable-protocols \
--enable-protocol=file \
--enable-protocol=pipe \
--enable-protocol=rtmp \
--enable-protocol=rtmpe \
--enable-protocol=rtmps \
--enable-protocol=rtmpt \
--enable-protocol=rtmpte \
--enable-protocol=rtmpts \
--disable-filters \
--enable-filter=aresample \
--enable-filter=asetpts \
--enable-filter=setpts \
--enable-filter=ass \
--enable-filter=scale \
--enable-filter=concat \
--enable-filter=atempo \
--enable-filter=movie \
--enable-filter=overlay \
--enable-filter=rotate \
--enable-filter=transpose \
--enable-filter=hflip \
--enable-zlib \
--disable-outdevs \
--disable-doc \
--disable-htmlpages \
--disable-manpages \
--disable-podpages \
--disable-txtpages \
--disable-programs \
--disable-ffplay \
--disable-ffmpeg \
--disable-debug \
--disable-ffprobe \
--disable-postproc \
--disable-avdevice \
--disable-symver \
--disable-stripping \
--extra-cflags="-Os -fPIC ${OPTIMIZE_CFLAGS}" \
--extra-ldflags="${ADDI_LDFLAGS}" \
${ADDITIONAL_CONFIGURE_FLAG}

make clean
make -j8
make install

# 合并到libffmpeg.so
${TOOLCHAIN}/bin/i686-linux-android-ld \
-rpath-link=${PLATFORM}/usr/lib \
-L${PLATFORM}/usr/lib \
-L${PREFIX}/lib \
-L${X264_LIB} \
-L${FDK_AAC_LIB} \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
${PREFIX}/libffmpeg.so \
libavcodec/libavcodec.a \
libavfilter/libavfilter.a \
libswresample/libswresample.a \
libavformat/libavformat.a \
libavutil/libavutil.a \
libswscale/libswscale.a \
${X264_LIB}/libx264.a \
${FDK_AAC_LIB}/libfdk-aac.a \
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
${TOOLCHAIN}/lib/gcc/i686-linux-android/4.9.x/libgcc.a

#回到根目录
cd ${ROOT_SOURCE}
