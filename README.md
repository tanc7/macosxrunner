Commands
o64-clang -target arm64-apple-darwin22 -isysroot ./target/SDK/MacOSX13.3.sdk -I./target/SDK/MacOSX13.3.sdk/usr/include -c hello.c -o hello.o

# Setup before osxcross
sudo apt update && sudo apt install -y \
git \
build-essential \
clang \
llvm \
cmake \
pkg-config \
libssl-dev \
libbz2-dev \
libsqlite3-dev \
zlib1g-dev \
libxml2-dev \
libxslt1-dev \
libreadline-dev \
libncurses5-dev \
libncursesw5-dev \
libffi-dev \
liblzma-dev \
curl \
wget \
unzip \
xz-utils \
python3 \
python3-pip \
python3-setuptools \
python3-wheel \
perl \
ruby \
autoconf \
automake \
libtool \
gperf \
bison \
flex \
gettext \
libtinfo-dev \
libedit-dev \
libncurses-dev \
uuid-dev \
git-lfs \
csh \
tcsh

# Grab SDK 10.13.3 for backwards compatibility

# Clone osxcross

# Compile the fileless loader


# Compile the object file
o64-clang -target x86_64-apple-macos12     -isysroot ./target/SDK/MacOSX13.3.sdk     -c start.s -o start.o

# Obfuscating with Tigress

 2059  export TIGRESS_HOME=/home/birb/Documents/tigress/tigress/3.1
 2066  export PATH=$TIGRESS_HOME:$PATH
