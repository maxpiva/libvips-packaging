#!/usr/bin/env bash
set -e

version_vips_short=${VERSION_VIPS%.[[:digit:]]*}

case "${PLATFORM#*-}" in
  x64) arch="64" ;;
  x86) arch="32" ;;
esac

mkdir -p /vips

# Unzip
unzip /packaging/build-win64-mxe/$version_vips_short/vips-dev-w$arch-web-${VERSION_VIPS}-static.zip -d /vips

cd /vips/vips-dev-$version_vips_short

# Move DLLs to the lib directory
cp bin/*.dll lib/

# Add third-party notices
curl -Os https://raw.githubusercontent.com/kleisauke/libvips-packaging/master/THIRD-PARTY-NOTICES.md

# Generate tarball
tar czf /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz \
  include \
  lib/glib-2.0 \
  lib/libvips.lib \
  lib/libglib-2.0.lib \
  lib/libgobject-2.0.lib \
  lib/*.dll \
  versions.json \
  THIRD-PARTY-NOTICES.md
advdef --recompress --shrink-insane /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz

# Remove working directories
rm -rf lib include versions.json THIRD-PARTY-NOTICES.md
