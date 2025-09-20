#!/bin/bash
# compilehello.sh
# Cross-compile a "Hello World" C binary for macOS
# Fully self-contained for fileless execution (no libc, no Foundation)

# --- Save original environment ---
OLD_PATH="$PATH"
OLD_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"

# --- Configuration ---
export OSXCROSS_ROOT="$HOME/Documents/osxcross"
export TARGET_DIR="$OSXCROSS_ROOT/target"

export PATH="$TARGET_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$TARGET_DIR/lib:$LD_LIBRARY_PATH"
export LD="/home/birb/Documents/osxcross/build/cctools-port/cctools/ld64/src/ld/ld"
# --- Source file ---
SRC="hello.c"
OUTPUT="hello_macho"

# Check source file exists
if [ ! -f "$SRC" ]; then
    echo "Source file $SRC not found!"
    export PATH="$OLD_PATH"
    export LD_LIBRARY_PATH="$OLD_LD_LIBRARY_PATH"
    exit 1
fi

# --- Compile using osxcross clang ---
# -nostdlib avoids libc
# -Wl,-e,_start sets the entry point symbol
# _start will contain only syscalls
#o64-clang -O2 -nostdlib -Wl,-e,_start "$SRC" -o "$OUTPUT"
#o64-clang -O2 -nostdlib -Wl,-e,_start hello.c -o hello
#o64-clang -target x86_64-apple-macos12  -isysroot ./target/SDK/MacOSX13.3.sdk -fuse-ld=$LD -arch x86_64 -fPIC -O2 -Wl,-no_pie hello.c -o hello_x86
o64-clang -c main.c -o main.o
# Compile hello.m (Objective-C source) and link against Foundation
o64-clang -c hello.m -o hello.o -framework Foundation
# Link both object files into a final Mach-O binary
o64-clang main.o hello.o -o hello_macho -framework Foundation
#o64-clang -target arm64-apple-darwin22 \
#  -isysroot ./target/SDK/MacOSX13.3.sdk \
#  -I./target/SDK/MacOSX13.3.sdk/usr/include \
#  -fPIC -c hello.c -o hello.o
# --- Verify output ---
if [ -f "$OUTPUT" ]; then
    echo "Compilation successful!"
    file "$OUTPUT"
else
    echo "Compilation failed."
    export PATH="$OLD_PATH"
    export LD_LIBRARY_PATH="$OLD_LD_LIBRARY_PATH"
    exit 1
fi

# --- Restore original environment ---
export PATH="$OLD_PATH"
export LD_LIBRARY_PATH="$OLD_LD_LIBRARY_PATH"

echo "Environment variables restored."

