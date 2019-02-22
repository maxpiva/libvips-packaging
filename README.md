# Packaging scripts

libvips and its dependencies are provided as pre-compiled shared libraries
for the most common operating systems and CPU architectures.

## Used by NetVips

During packaging of NetVips, these binaries are fetched as tarballs from 
this repository via HTTPS and stored within the NuGet package (see
[`build.cake`](https://github.com/kleisauke/net-vips/blob/master/build.cake)
for details).

Finally, the created `.nupkg` are uploaded on NuGet. You can find them here:
* [NetVips.Native.win-x64](https://www.nuget.org/packages/NetVips.Native.win-x64)
* [NetVips.Native.win-x86](https://www.nuget.org/packages/NetVips.Native.win-x86)
* [NetVips.Native.linux-x64](https://www.nuget.org/packages/NetVips.Native.linux-x64)
* [NetVips.Native.linux-musl-x64](https://www.nuget.org/packages/NetVips.Native.linux-musl-x64)
* [NetVips.Native.osx-x64](https://www.nuget.org/packages/NetVips.Native.osx-x64)

The version number of these NuGet packages is in sync with libvips' version number.

## Creating a tarball

Most people will not need to do this; proceed with caution.

Run the top-level [build script](build.sh) without parameters for help.

### Linux

One [build script](build/lin.sh) is used to (cross-)compile
the same shared libraries within multiple containers.

* [x64 glibc](linux-x64/Dockerfile)
* [x64 musl](linux-musl-x64/Dockerfile)

### Windows

The output of libvips' [build-win64-mxe](https://github.com/libvips/build-win64-mxe)
"web" target is [post-processed](build/win.sh) within a [container](win32/Dockerfile).

### OS X

Uses Travis CI to generate a binary tarball
of libvips and its dependencies.

Builds dylib files via homebrew
then modifies their depedency paths to be
the relative `@loader_path` using `install_name_tool`.

The resulting file is transferred to S3 by setting
[various environment variables](https://docs.travis-ci.com/user/uploading-artifacts).

## Licences

These scripts are licensed under the terms of the
[Apache 2.0 Licence](LICENSE).

The shared libraries contained in the tarballs
are distributed under the terms of the following licences,
all of which are compatible with the Apache 2.0 Licence.

Use of libraries under the terms of the LGPLv3 is via the
"any later version" clause of the LGPLv2 or LGPLv2.1.

| Library       | Used under the terms of                                                                                  |
|---------------|----------------------------------------------------------------------------------------------------------|
| cairo         | Mozilla Public License 2.0                                                                               |
| expat         | MIT Licence                                                                                              |
| fontconfig    | [fontconfig Licence](https://cgit.freedesktop.org/fontconfig/tree/COPYING) (BSD-like)                    |
| freetype      | [freetype Licence](http://git.savannah.gnu.org/cgit/freetype/freetype2.git/tree/docs/FTL.TXT) (BSD-like) |
| fribidi       | LGPLv3                                                                                                   |
| gettext       | LGPLv3                                                                                                   |
| giflib        | MIT Licence                                                                                              |
| glib          | LGPLv3                                                                                                   |
| harfbuzz      | MIT Licence                                                                                              |
| lcms          | MIT Licence                                                                                              |
| libcroco      | LGPLv3                                                                                                   |
| libexif       | LGPLv3                                                                                                   |
| libffi        | MIT Licence                                                                                              |
| libgsf        | LGPLv3                                                                                                   |
| libjpeg-turbo | [zlib License, IJG License](https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md)       |
| libpng        | [libpng License](http://www.libpng.org/pub/png/src/libpng-LICENSE.txt)                                   |
| librsvg       | LGPLv3                                                                                                   |
| libtiff       | [libtiff License](http://www.libtiff.org/misc.html) (BSD-like)                                           |
| libuuid       | New BSD License                                                                                          |
| libvips       | LGPLv3                                                                                                   |
| libwebp       | New BSD License                                                                                          |
| libxml2       | MIT Licence                                                                                              |
| pango         | LGPLv3                                                                                                   |
| pixman        | MIT Licence                                                                                              |
| zlib          | [zlib Licence](https://github.com/madler/zlib/blob/master/zlib.h)                                        |
