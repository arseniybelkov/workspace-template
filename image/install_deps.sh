#!/bin/sh

set -e -x

echo "Installing dependencies"

apt update

DEBIAN_FRONTEND="noninteractive" apt -y install tzdata

apt install -y software-properties-common

apt install -y wget rsync

# LLVM
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
add-apt-repository -y "deb http://apt.llvm.org/noble/ llvm-toolchain-noble-19 main"

# CMake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add -
apt-add-repository 'deb https://apt.kitware.com/ubuntu/ noble main'

apt update

apt install -y \
	ssh \
	vim \
	make \
	cmake \
	build-essential \
	ninja-build \
	git \
	linux-tools-common \
	linux-tools-generic \
	g++-13 \
	clang-19 \
	clang-format-19 \
	clang-tidy-19 \
	libc++-19-dev \
	libc++abi-19-dev \
	libclang-rt-19-dev \
	clangd-19 \
	lldb-19 \
	gdb \
	binutils-dev \
	libdwarf-dev \
	libdw-dev \
	ca-certificates \
	openssh-server \
	autoconf \
	man-db \
	curl

curl -LsSf https://astral.sh/uv/install.sh | sh
