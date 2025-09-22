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

# ⚠️ Legal Disclaimer

**macosxrunner** is provided **strictly for educational, research, and defensive cybersecurity purposes**. By using or interacting with this repository, you agree to the following terms:

1. **Educational Intent**  
   This project demonstrates techniques for loading Mach-O binaries on macOS. All examples in this repository are **harmless**, such as compiled "Hello World" binaries, and are intended **solely for learning, experimentation, and cybersecurity research in controlled environments**.

2. **Prohibition on Unauthorized Use**  
   You **may not** deploy, distribute, or execute any binaries or techniques on systems, networks, or users without explicit permission. Unauthorized use may constitute a violation of local, national, or international laws.

3. **Risk Acknowledgment**  
   Any actions performed with this repository are the **sole responsibility of the user**. The author **assumes no liability** for any damages, data loss, or legal consequences arising from its use.

4. **Ethical Responsibility**  
   This repository is for **educational purposes only**. Techniques demonstrated should **never be used against systems you do not own or have explicit authorization to test**.

5. **Compliance Requirement**  
   By using this repository, you confirm that you will **comply with all applicable laws and regulations** and exercise ethical judgment in all activities.

---

> ⚠️ **Warning:** Misuse of these techniques on unauthorized systems can result in severe legal consequences. Use responsibly.

Sent from my iPhone
