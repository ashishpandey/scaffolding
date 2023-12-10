#!/bin/bash

set -e

RCLONE_SYNC_FLAGS=""
# RCLONE_SYNC_FLAGS="--dry-run"

rclone sync --verbose ${RCLONE_SYNC_FLAGS} \
    --no-update-modtime --checksum \
    --exclude-from /mnt/user/data/rclone_excludes \
    /mnt/user/data/Data/NASDocs/ ap-gdrive:/badagodaam/documents/
