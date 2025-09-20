// hello.c — x86-64 macOS, fileless, _start entry
// Compile with OSXCROSS clang and ld

void _start(void) __attribute__((naked, used, visibility("default")));
void _start(void) {
    asm(
        // write syscall: rax=0x2000004, rdi=1 (stdout), rsi=message, rdx=14
        "mov $0x2000004, %rax\n\t"
        "mov $1, %rdi\n\t"
        "lea message(%rip), %rsi\n\t"
        "mov $14, %rdx\n\t"
        "syscall\n\t"
        // exit syscall: rax=0x2000001, rdi=0
        "mov $0x2000001, %rax\n\t"
        "xor %rdi, %rdi\n\t"
        "syscall\n\t"
        // embed string in .text section
        "message: .ascii \"Hello, World!\\n\""
    );
}
