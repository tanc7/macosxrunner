# Compile main.c
o64-clang -c main.c -o main.o

# Compile Objective-C code
o64-clang -c hello.m -o hello.o -framework Foundation

# Compile obfuscated wrapper (the output of Tigress stub)
o64-clang -c hello_wrapper_obf.c -o hello_wrapper_obf.o

# Link everything
o64-clang main.o hello.o hello_wrapper_obf.o -o hello_macho -framework Foundation
