FROM alpine:3.11
LABEL maintainer="Kleis Auke Wolthuizen <info@kleisauke.nl>"

# Create Alpine 3.11 (musl 1.1.24) container suitable for building Linux x64 binaries

# Build dependencies
RUN \
  apk update && apk upgrade && \
  apk --update --no-cache add \
    autoconf \
    automake \
    binutils \
    build-base \
    cmake \
    curl \
    findutils \
    git \
    glib-dev \
    gobject-introspection-dev \
    gperf \
    gtk-doc \
    intltool \
    jq \
    libtool \
    linux-headers \
    nasm \
    ninja \
    python3 \
    shared-mime-info \
    texinfo && \
  apk --update --no-cache --repository https://alpine.global.ssl.fastly.net/alpine/edge/community/ add advancecomp && \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  pip3 install meson

# https://github.com/mesonbuild/meson/issues/314#issuecomment-559899679
RUN \
  cd $(dirname `python3 -c "import mesonbuild as _; print(_.__path__[0])"`) && \
  curl https://gist.github.com/kleisauke/0b766e9d9867bb9c7c152ec9e950acb3/raw/b09492a4178099cc6e7541a423c2e84897e28aa8/0001-Only-fix-RPATH-if-install_rpath-is-not-empty.patch | patch -p1

# Compiler settings
ENV \
  PATH="/root/.cargo/bin:$PATH" \
  PLATFORM="linux-musl-x64" \
  RUST_TARGET="x86_64-unknown-linux-musl" \
  FLAGS="-O3 -fPIC"

# Musl defaults to static libs but we need them to be dynamic for host toolchain.
# The toolchain will produce static libs by default.
ENV \
  RUSTFLAGS="-C target-feature=-crt-static"

COPY Toolchain.cmake /root/
