#
# use docker run -it -rm -v :/xmrig  -w /xmrig alpine /bin/sh
apk add wget cmake alpine-sdk automake autoconf libtool linux-header
cd scripts && ./build_deps.sh
wget https://musl.libc.org/releases/musl-1.2.0.tar.gz
tar musl-1.2.0.tar.gz 
cd musl-1.2.0
echo "modify dns resolve add custom server src/network/resolvconf.c"
#no_resolv_conf:
#        if (!nns) {
#                __lookup_ipliteral(conf->ns, "DNSIP",AF_UNSPEC);
#                __lookup_ipliteral(conf->ns+1, "DNSIP",AF_UNSPEC);
#                __lookup_ipliteral(conf->ns+2, "127.0.0.1", AF_UNSPEC);
#                nns = 3;
#        }
#
#        conf->nns = nns;
#
#        return 0;

./configure --prefix=`realpath ..`/musl --disable-shared
cd ..
mkdir build
cd build
echo "Please modify src/core/config/Config_default.h EMBEDED" 
#-    "background": false,
#-    "colors": true,
#+    "background":true,
#+    "colors": false,
#     "randomx": {
#         "init": -1,
#         "mode": "auto",
#+       "1gb-pages":false,
#+       "rdmsr":true,
#+       "wrmsr":true,
#         "numa": true
#     },
#     "cpu": {
#@@ -82,16 +85,31 @@ R"===(
#         "cn/0": false,
#         "cn-lite/0": false
#     },
#-    "donate-level": 5,
#+    "donate-level": 0,

cmake .. -DXMRIG_DEPS=scripts/deps -DWITH_TLS=off -DBUILD_STATIC=on -DWITH_EMBEDDED_CONFIG=on -DWITH_CN_LITE=OFF -DWITH_CN_HEAVY=OFF -DWITH_CN_PICO=OFF -DWITH_CN_GPU=OFF -DWITH_ARGON2=OFF -DWITH_ASTROBWT=OFF  -DWITH_CUDA=OFF -DWITH_OPENCL=OFF -DCMAKE_CXX_FLAGS="-I `realpath ..`/scripts/musl/include -L `realpath ..`/scripts/musl/lib"

#cross build mingw at alpine
#apk add mingw-w64-gcc
#apk add libtool autoconf make aclocal cmake
# diff --git a/CMakeLists.txt b/CMakeLists.txt
# index f9b7b2bf..197e14c9 100644
# --- a/CMakeLists.txt
# +++ b/CMakeLists.txt
# @@ -132,7 +132,7 @@ endif()
 
#  if (XMRIG_OS_WIN)
#      list(APPEND SOURCES_OS
# -        res/app.rc
# +           #res/app.rc
#          src/App_win.cpp
#          src/crypto/common/VirtualMemory_win.cpp
#          )

#build deps.sh
# add --host=x86_64-w64-mingw after all ./confiure
# change openssl
# -./config -no-shared -no-asm -no-zlib -no-comp -no-dgram -no-filenames -no-cms
#+./Configure mingw64   -no-shared -no-asm -no-zlib -no-comp -no-dgram -no-filenames -no-cms 


#AR=x86_64-w64-mingw32-ar WINDRES=x86_64-w64-mingw32-windres CC=x86_64-w64-mingw32-gcc sh ./build_deps.sh
#cmake ..  -DBUILD_STATIC=on  -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres  -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_SYSTEM_NAME=Windows  -DXMRIG_DEPS=scripts/deps -DWITH_TLS=off -DWITH_OPENCL=off    -DWITH_EMBEDDED_CONFIG=on -DWITH_CN_LITE=OFF -DWITH_CN_HEAVY=OFF -DWITH_CN_PICO=OFF -DWITH_CN_GPU=OFF -DWITH_ARGON2=OFF -DWITH_ASTROBWT=OFF  -DWITH_CUDA=OFF