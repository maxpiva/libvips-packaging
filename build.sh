#!/usr/bin/env bash
set -e

if [ $# -lt 1 ]; then
  echo
  echo "Usage: $0 VERSION [PLATFORM]"
  echo "Build shared libraries for libvips and its dependencies via containers"
  echo
  echo "Please specify the libvips VERSION, e.g. 8.10.0-rc1"
  echo
  echo "Optionally build for only one PLATFORM, defaults to building for all"
  echo
  echo "Possible values for PLATFORM are:"
  echo "- linux-x64"
  echo "- linux-musl-x64"
  echo "- linux-arm"
  echo "- linux-arm64"
  echo "- win-x64"
  echo "- win-x86"
  echo "- osx-x64"
  echo
  exit 1
fi

version_vips="$1"
version_vips_short=${version_vips%.[[:digit:]]*}
platform="${2:-all}"

# macOS
# Note: we intentionally don't build these binaries inside a Docker container
if [ $platform = "osx-x64" ] && [ "$(uname)" == "Darwin" ]; then
  # Use Clang provided by XCode
  export CC="clang"
  export CXX="clang++"

  export VERSION_VIPS=$version_vips
  export PLATFORM=$platform

  # 10.9 should be a good minimal release target
  export MACOSX_DEPLOYMENT_TARGET="10.9"

  # Added -fno-stack-check to workaround a stack misalignment bug on macOS 10.15
  # See:
  # https://forums.developer.apple.com/thread/121887
  # https://trac.ffmpeg.org/ticket/8073#comment:12
  export FLAGS="-O3 -fPIC -fno-stack-check"

  . $PWD/build/osx.sh

  exit 0
fi

# Is docker available?
if ! [ -x "$(command -v docker)" ]; then
  echo "Please install docker"
  exit 1
fi

# Update base images
for baseimage in centos:7 debian:buster alpine:3.11; do
  docker pull $baseimage
done

# Windows (x64 and x86)
for flavour in win-x64 win-x86; do
  if [ $platform = "all" ] || [ $platform = $flavour ]; then
    echo "Building $flavour..."
    docker build -t vips-dev-win32 win32
    docker run --rm -e "VERSION_VIPS=${version_vips}" -e "PLATFORM=${flavour}" -v $PWD:/packaging vips-dev-win32 sh -c "/packaging/build/win.sh"
  fi
done

# Linux (x64, ARMv7, ARM64v8)
for flavour in linux-x64 linux-musl-x64 linux-arm linux-arm64; do
  if [ $platform = "all" ] || [ $platform = $flavour ]; then
    echo "Building $flavour..."
    docker build -t vips-dev-$flavour $flavour
    docker run --rm -e "VERSION_VIPS=${version_vips}" -v $PWD:/packaging vips-dev-$flavour sh -c "/packaging/build/lin.sh"
  fi
done

# Display checksums
sha256sum *.tar.gz
