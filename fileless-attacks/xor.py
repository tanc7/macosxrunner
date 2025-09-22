#!/usr/bin/env python3
import os

# Configuration
input_file = "hello_macho"              # Original Mach-O
output_file = "hello_macho_encrypted"   # Encrypted output
key_len = 4                              # Length of random XOR key in bytes

# Generate random XOR key
xor_key = os.urandom(key_len)

# Read original Mach-O
with open(input_file, "rb") as f:
    original = f.read()

# Encrypt with repeating XOR key
encrypted = bytearray(original[i] ^ xor_key[i % key_len] for i in range(len(original)))

# Write encrypted payload to disk
with open(output_file, "wb") as f:
    f.write(encrypted)

# Print key in '\x..' format for reference
print("Random XOR Key:", ''.join(f"\\x{b:02x}" for b in xor_key))
print(f"Encrypted payload written to: {output_file}")

