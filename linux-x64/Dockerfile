FROM centos:7
LABEL maintainer "Kleis Auke Wolthuizen <info@kleisauke.nl>"

# Create CentOS 7 (glibc 2.17) container suitable for building Linux x64 binaries

# Build dependencies
RUN \
  yum update -y && \
  yum install -y epel-release centos-release-scl && \
  yum group install -y "Development Tools" && \
  yum install -y --setopt=tsflags=nodocs \
    advancecomp \
    cmake3 \
    devtoolset-8-gcc \
    devtoolset-8-gcc-c++ \
    git \
    glib2-devel \
    gobject-introspection-devel \
    gperf \
    gtk-doc \
    jq \
    nasm \
    prelink \
    ninja-build && \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  ln -s /usr/bin/cmake3 /usr/bin/cmake && \
  ln -s /usr/bin/ninja-build /usr/bin/ninja && \
  pip3 install meson

# https://github.com/mesonbuild/meson/issues/314#issuecomment-559899679
RUN \
  cd $(dirname `python3 -c "import mesonbuild as _; print(_.__path__[0])"`) && \
  curl https://gist.github.com/kleisauke/0b766e9d9867bb9c7c152ec9e950acb3/raw/b09492a4178099cc6e7541a423c2e84897e28aa8/0001-Only-fix-RPATH-if-install_rpath-is-not-empty.patch | patch -p1

# Compiler settings
ENV \
  CC="/opt/rh/devtoolset-8/root/usr/bin/gcc" \
  CXX="/opt/rh/devtoolset-8/root/usr/bin/g++" \
  PATH="/root/.cargo/bin:$PATH" \
  PLATFORM="linux-x64" \
  FLAGS="-s -O3 -ffast-math -fPIC"

COPY Toolchain.cmake /root/
