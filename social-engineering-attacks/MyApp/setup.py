from setuptools import setup

APP = ['myapp.py']
OPTIONS = {
    'argv_emulation': True,
    'packages': ['jaraco.text'],  # explicitly include missing package
    'plist': {
        'CFBundleName': 'MyApp',
        'CFBundleShortVersionString': '0.1',
        'CFBundleIdentifier': 'com.example.myapp',
    },
    'packages': [],
}

setup(
    app=APP,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
