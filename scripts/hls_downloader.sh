#!/bin/bash

## example:
# https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8

base_folder="$(mktemp -d)"

video_dir="$1"
base_playlist="$2"
base_url="$3/${folder_name}"

if [ "$#" -lt "2" ]; then
    echo "\
    Usage: \n\
        $0 \${video_dir} \${url} \${[optional] url of your hosting server}\
    "
    exit
fi

get_file () {
    local url="$1"; shift
    local file_path=$(wget "$*" "${url}" 2>&1 | sed -n 's/Saving to: .\(.\+\).$/\1/p')
    echo ${file_path}
}

get_file_to_base () {
    local file_path=$(cd ${base_folder} && get_file "$1" "-r")
    echo "${base_folder}/${file_path}"
}

download_playlist () {

    local playlist_url="$1"
    local playlist_base_url=$(dirname "${playlist_url}")

    if [ -e "$2" ]; then
        local playlist_path="$2"
    else
        local playlist_path=$(get_file_to_base "${playlist_url}")
    fi

    cat ${playlist_path} | sed -n 's;#EXT-X-.*URI="\(.*\).*";\1;p' | while read fn; do
        get_file_to_base "${playlist_base_url}/${fn}"
    done

    cat ${playlist_path} | grep '^[^#]\+' | while read fn; do
        local file_url="${playlist_base_url}/${fn}"
        local file_path=$(get_file_to_base "${file_url}")
        if [ "$(grep -m 1 . ${file_path})" == "#EXTM3U" ]; then 
            download_playlist "${file_url}" "${file_path}"
        fi
    done

    if [ -n "${base_url}" ]; then
        ## update absolute path
        sed -i "s;[a-zA-Z]://;${base_url};g" ${playlist_path}
    else
        ## or update absolute path to relative path
        relative_base=$(realpath --relative-to="${playlist_path}" "${base_folder}")
        sed -i "s;[a-zA-Z]://;${relative_base}/;g" ${playlist_path}
    fi
}

download_playlist ${base_playlist}
mv ${base_folder} ${video_dir}
