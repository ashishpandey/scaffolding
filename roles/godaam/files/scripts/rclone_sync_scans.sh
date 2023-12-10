#!/bin/bash

set -e

if [ "x$1" = "x--resync" ]; then
    RCLONE_RESYNC_FLAG="--resync"
fi

rclone bisync --verbose ${RCLONE_RESYNC_FLAG} \
    --force \
    --check-access \
    --exclude-from /mnt/user/data/rclone_excludes \
    ap-gdrive:/epson/ /mnt/user/data/Data/Scans/ 
