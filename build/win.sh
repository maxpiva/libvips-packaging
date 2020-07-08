#!/usr/bin/env bash
set -e

version_vips_short=${VERSION_VIPS%.[[:digit:]]*}

case "${PLATFORM#*-}" in
  x64) bits="64" ;;
  x86) bits="32" ;;
esac

# Fetch and unzip
mkdir /vips
cd /vips
curl -LOs https://github.com/libvips/build-win64-mxe/releases/download/v${VERSION_VIPS}/vips-dev-w${bits}-web-${VERSION_VIPS}-static.zip
unzip vips-dev-w${bits}-web-${VERSION_VIPS}-static.zip

cd /vips/vips-dev-${version_vips_short}

# Move DLLs to the lib directory
cp bin/*.dll lib/

# Add third-party notices
curl -Os https://raw.githubusercontent.com/kleisauke/libvips-packaging/master/THIRD-PARTY-NOTICES.md

# Create tarball
tar czf /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz \
  include \
  lib/glib-2.0 \
  lib/libvips.lib \
  lib/libglib-2.0.lib \
  lib/libgobject-2.0.lib \
  lib/*.dll \
  versions.json \
  THIRD-PARTY-NOTICES.md

# Recompress using AdvanceCOMP, ~5% smaller
advdef --recompress --shrink-insane /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz

# Allow tarballs to be read outside container
chmod 644 /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz

# Remove working directories
rm -rf lib include versions.json THIRD-PARTY-NOTICES.md
