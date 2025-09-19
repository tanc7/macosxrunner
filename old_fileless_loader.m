// File: fileless_loader.m
#import <Foundation/Foundation.h>
#import <mach-o/loader.h>
#import <sys/mman.h>
#import <string.h>
#import <stdio.h>

typedef void (*entry_t)(void);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <path_to_macho>\n", argv[0]);
        return 1;
    }

    const char *path = argv[1];
    NSData *machoData = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:path]];
    if (!machoData) {
        fprintf(stderr, "Failed to read Mach-O file\n");
        return 1;
    }

    size_t size = [machoData length];

    // Allocate executable memory
    void *mem = mmap(NULL, size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANON | MAP_PRIVATE, -1, 0);
    if (mem == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    // Copy Mach-O into memory
    memcpy(mem, [machoData bytes], size);

    // Parse Mach-O header
    struct mach_header_64 *header = (struct mach_header_64 *)mem;
    if (header->magic != MH_MAGIC_64) {
        fprintf(stderr, "Not a valid 64-bit Mach-O\n");
        return 1;
    }

    struct load_command *lc = (struct load_command *)(header + 1);
    uint64_t entryoff = 0;

    for (uint32_t i = 0; i < header->ncmds; i++) {
        if (lc->cmd == LC_MAIN) {
            struct entry_point_command *ep = (struct entry_point_command *)lc;
            entryoff = ep->entryoff;
            break;
        }
        lc = (struct load_command *)((char *)lc + lc->cmdsize);
    }

    if (entryoff == 0) {
        fprintf(stderr, "LC_MAIN not found\n");
        return 1;
    }

    printf("Entry point offset: 0x%llx\n", entryoff);

    // Jump to entry point
    entry_t func = (entry_t)((char *)mem + entryoff);
    func();

    return 0;
}
