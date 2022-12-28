#!/bin/bash

# ensure unicode filenames are supported
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export G_FILENAME_ENCODING="@locale"
export G_BROKEN_FILENAMES="1"

srcipt_ok=false

if [ "$#" -le 2 ]; then
    /usr/local/emhttp/webGui/scripts/notify -i normal -s "Sync Failure" -d "Wrong number or arguments: $#"
    exit 1
fi

src=$1
if [ ! -d $src ]; then
    /usr/local/emhttp/webGui/scripts/notify -i normal -s "Sync Failure" -d "Source dir does not exist: $src"
    exit 2
fi

dst=$2
if [ ! -d $dst ]; then
    /usr/local/emhttp/webGui/scripts/notify -i normal -s "Sync Failure" -d "Destination dir does not exist: $dst"
    exit 2
fi

name=${3:-$src}
echo "Sync ($name): $src => $dst"
/usr/local/emhttp/webGui/scripts/notify -i normal -s "Sync Started" -d "Synchronizing $name"

rsync --archive --verbose --delete $src $dst
if [[ $? -eq 0 ]]; then
    srcipt_ok=true
    /usr/local/emhttp/webGui/scripts/notify -i normal -s "Sync Complete" -d "Synchronized $name successfully"
fi

if [ "$script_ok" == false ]; then
    /usr/local/emhttp/webGui/scripts/notify -i warning -s "Sync failed" -d "Error. Failed to synchronize $name"
fi
