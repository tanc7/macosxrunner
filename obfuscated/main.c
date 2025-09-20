#include <stdio.h>
#include "hello.h"

int main() {
    // Redirect stderr to stdout so you can read NSLog output
    fflush(stdout);
    freopen("/dev/stdout", "w", stderr);

    hello_world_c();  // Call the Objective-C function

    return 0;
}
