#!/usr/bin/python3

##
# references:
# https://www.tutorialspoint.com/How-do-we-do-a-file-upload-using-Python-CGI-Programming
# Usage:
# curl -F "filename=@localfile" -F http://localhost/cgi-bin/upload_py.cgi

import cgi
import cgitb
import os

base_upload_url = "C:\\Users\\Public\\Downloads"
accept_item = ["image"]

## so to log future output
print("Content-type:text/plaintext\n")

form = cgi.FieldStorage()
message = ""

if os.access(base_upload_url, os.X_OK | os.W_OK) == False:
    message = "No permission"
elif form.length <= 0:
    message = "No data"
else:
    ## Main
    for key in set(accept_item) & set(form.keys()):

        fileitem = form[key]
        filename = fileitem.filename

        if filename is None:
            print("Unexpect input from '%s' !" % (key))
        else:
            try:
                # strip leading path from file name to avoid directory traversal attacks
                fn = os.path.basename(filename)  # .replace("\\", "/")
                path = base_upload_url + "/" + fn

                with open(path, "wb") as f:
                    f.write(fileitem.file.read())

                print("File '%s' uploaded !" % (filename))

            except Exception as e:
                ## For debug
                # message = e
                break

if message != "":
    print("%s" % (message))
