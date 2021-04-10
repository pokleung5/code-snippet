# Scripts

## hls_downloader.sh <url>

- a very generic solution to download all files mentioned in those m3u8 playlist

----

## upload_py.cgi

- Update variable
    - base_upload_url = path for the destination
    - accept_item = list of accepting key
- Server Side:
    - place the file to cgi-bin directory
- Client Side:
    - curl -F "key=@localfile" http://localhost/cgi-bin/upload_py.cgi

