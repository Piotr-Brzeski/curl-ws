#!/bin/sh
# Build libcurl with websocket support for macOS
#
# Created by Piotr Brzeski on 2023-12-03.
# Copyright © 2023 Brzeski.net. All rights reserved.

PREFIX=`pwd`/build

curl -O https://curl.se/download/curl-8.4.0.tar.bz2 || exit 1
tar xjf curl-8.4.0.tar.bz2 || exit 1
pushd curl-8.4.0 || exit 1
autoconf || exit 1
./configure \
  --enable-websockets \
  --disable-shared \
  --disable-debug \
  --disable-dependency-tracking \
  --disable-silent-rules \
  --with-ssl=/opt/homebrew/opt/openssl \
  --without-ca-bundle \
  --without-ca-path \
  --with-ca-fallback \
  --with-secure-transport \
  --with-default-ssl-backend=openssl \
  --with-libidn2 \
  --with-librtmp \
  --with-libssh2 \
  --without-libpsl \
  --with-gssapi \
  --prefix="$PREFIX" \
  || exit 1

make -j 10 || exit 1
make install || exit 1
popd || exit 1

mkdir macos || exit 1
mv build/lib/libcurl.a macos/libcurl-ws.a || exit 1
mv build/include/curl macos/curl-ws || exit 1

exit 0
