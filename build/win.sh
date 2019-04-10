#!/usr/bin/env bash
set -e

version_vips_major=$(echo $VERSION_VIPS | cut -d. -f1)
version_vips_minor=$(echo $VERSION_VIPS | cut -d. -f2)

case "${PLATFORM#*-}" in
  x64) arch="64" ;;
  x86) arch="32" ;;
esac

mkdir -p /vips

echo "Unzipping"
unzip /packaging/build-win64-mxe/$version_vips_major.$version_vips_minor/vips-dev-w$arch-web-${VERSION_VIPS}-static.zip -d /vips

cd /vips/vips-dev-$version_vips_major.$version_vips_minor
cp bin/*.dll lib/

echo "Creating tarball"
tar czf /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz include lib/glib-2.0 lib/libvips.lib lib/libglib-2.0.lib lib/libgobject-2.0.lib lib/*.dll versions.json
echo "Shrinking tarball"
advdef --recompress --shrink-insane /packaging/libvips-${VERSION_VIPS}-${PLATFORM}.tar.gz
