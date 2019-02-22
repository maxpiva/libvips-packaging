#!/usr/bin/env bash

# Clean working directories
rm -rf lib include
mkdir lib include

# Use pkg-config to automagically find and copy necessary header files
for path in $(pkg-config --cflags --static vips libcroco-0.6 | tr ' ' '\n' | grep '^-I' | cut -c 3- | sort | uniq); do
  cp -R ${path}/ include;
done;
rm include/gettext-po.h

# Manually copy header files for jpeg and giflib
cp /usr/local/opt/jpeg/include/*.h include
cp /usr/local/opt/giflib/include/*.h include

# Pack only the relevant shared libraries
# and modify all dylib file dependencies to use relative paths
function copydeps {
  local file=$1
  local dest_dir=$2

  # dylib names can have extra versioning in ...
  # libgobject-2.0.0.dylib -> libgobject-2.0.dylib
  local base=$(basename $file | sed -E "s/(\.[0-9])\.[0-9]./\1./")

  while read dep; do
    base_dep=$(basename $dep | sed -E "s/(\.[0-9])\.[0-9]./\1./")

    echo "$base depends on $base_dep"
    cp -Ln $dep $dest_dir/$base_dep
    chmod 644 $dest_dir/$base_dep

    install_name_tool -id @loader_path/$base_dep $dest_dir/$base_dep

    if [ $base != $base_dep ]; then
      install_name_tool -change $dep @loader_path/$base_dep $dest_dir/$base

      # Call this function (recursive) on each dependency of this library
      copydeps $dest_dir/$base_dep $dest_dir
    fi
  done < <(otool -LX $file | awk '{print $1}' | grep '/usr/local')
}

copydeps $(brew --prefix vips)/lib/libvips.42.dylib lib

# Fix file permissions
chmod 644 include/*.h
chmod 644 lib/*.dylib

# Generate tarball
TARBALL=libvips-$(pkg-config --modversion vips)-osx-x64.tar.gz
tar cfz "${TARBALL}" include lib
advdef --recompress --shrink-insane "${TARBALL}"

# Remove working directories
rm -rf lib include

# Display checksum
shasum *.tar.gz
