# Packaging scripts

libvips and its dependencies are provided as pre-compiled shared libraries
for the most common operating systems and CPU architectures.

## Used by NetVips

During packaging of NetVips, these binaries are fetched as tarballs from 
this repository via HTTPS and stored within the NuGet package (see
[`Build.cs`](https://github.com/kleisauke/net-vips/blob/master/build/Build.cs)
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

### macOS

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
are distributed under the terms of
[various licences](THIRD-PARTY-NOTICES.md),
all of which are compatible with the Apache 2.0 Licence.
