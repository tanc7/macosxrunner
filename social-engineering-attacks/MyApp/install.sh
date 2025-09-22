python3 -m venv .
source ./bin/activate
python3 -m pip install py2app
python3 -m pip install jaraco.text
mkdir MyApp
cd MyApp/
python setup.py py2app
open ./dist/MyApp.app/Contents/MacOS
open ./dist/MyApp.app/Contents/MacOS/MyApp 
