FROM alpine:3.10
LABEL maintainer "Kleis Auke Wolthuizen <info@kleisauke.nl>"

# Create Alpine 3.10 (musl 1.1.22) container suitable for building Linux x64 binaries

# Build dependencies
RUN \
  apk update && apk upgrade && \
  apk --update --no-cache add \
    build-base \
    curl \
    git \
    autoconf \
    automake \
    libtool \
    intltool \
    shared-mime-info \
    nasm \
    gtk-doc \
    texinfo \
    gperf \
    glib-dev \
    gobject-introspection-dev \
    findutils \
    jq \
    linux-headers \
    cmake \
    binutils \
    python3 \
    ninja && \
  apk --update --no-cache --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ add advancecomp && \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  pip3 install meson

# Compiler settings
ENV \
  PATH="/root/.cargo/bin:$PATH" \
  PLATFORM="linux-musl-x64" \
  FLAGS="-O3"

# Musl defaults to static libs but we need them to be dynamic for host toolchain.
# The toolchain will produce static libs by default.
ENV \
  RUSTFLAGS="-C target-feature=-crt-static"

COPY Toolchain.cmake /root/
