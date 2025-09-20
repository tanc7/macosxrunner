#import <Foundation/Foundation.h>
#import "hello.h"

void hello_world(void) {
    @autoreleasepool {
        // Pipe stderr to stdout for reading in C
        NSLog(@"Hello World!");
    }
}
