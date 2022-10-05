#!/bin/bash

set -e

echo "START media backup"
rsync -a /volume2/media /volume3/backup
echo "FINISH media backup"

echo "START Emby backup"
rsync -a /volume2/Emby /volume3/backup
echo "FINISH Emby backup"
