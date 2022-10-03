#!/bin/bash

set -e

src="/volume1/share/GigaMac/LRExport"
dst="/volume1/share/Photos/4k"
img_size="3840x2160"

imbin="/usr/local/imagemagick/bin/"

function log() {
	echo "$(date +"%Y-%d-%m %T") - $1"
}

function img_resize() {
  local img=$1
  if [[ "$img" == *.jpg ]]; then
  	$imbin/convert "$src/$img" -resize ${img_size}^\> "$dst/$img" \
		&& touch --no-create -m --reference=$src/$img --date="+1 sec" $dst/$img
  fi
}

rsync --dry-run --recursive --itemize-changes --update --delete --delete-excluded \
	--exclude '@eaDir' --exclude 'Thumbs.db' $src/ $dst/ | while read -r line ; do
    echo "$line"
    read -r op file <<< "$line"

    if [ "x$op" == "x*deleting" ]; then
	  log "removing $dst/$file"
      rm -rf $dst/$file
	else
	  op1=$(echo $op | cut -b 1-2)
	  tsChanged=$(echo $op | cut -b 5)

	  if [ "x$op1" == "xcd" ]; then
		mkdir -p $dst/$file
	  elif [ "x$op1" == "x>f" ]; then
		if [ "x$tsChanged" == "xT"  ]; then
		  log "update $dst/$file"
		  img_resize "$file"
		elif [ "x$tsChanged" == "x+" ]; then
		  log "add $dst/$file"
		  img_resize "$file"
		fi
	  fi
	fi

done
