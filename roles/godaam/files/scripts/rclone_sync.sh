#!/bin/bash

rclone bisync --verbose \
    --force \
    --check-access \
    --exclude-from /mnt/user/data/rclone_excludes \
    ap-gdrive:/epson/ /mnt/user/data/Data/Scans/ 
