#!/bin/bash

set -e

src="/volume1/share/GigaMac/LRExport"
dst="/volume1/share/Photos/4k"
img_size="3840x2160"

imbin="/usr/local/imagemagick/bin/"

function img_resize() {
  local img=$1
  $imbin/convert "$src/$img" -resize ${img_size}^\> "$dst/$img" \
		&& touch --no-create -m --reference=$src/$img --date="+1 sec" $dst/$img
}

rsync --dry-run --recursive --itemize-changes --update --delete --exclude '@eaDir' $src/ $dst/ | while read -r line ; do
    echo "$line"
    read -r op file <<< "$line"

    if [ "x$op" == "x*deleting" ]; then
      rm -f $dst/$file
	else
	  op1=$(echo $op | cut -b 1-2)
	  tsChanged=$(echo $op | cut -b 5)

	  if [ "x$op1" == "xcd" ]; then
		mkdir -p $dst/$file
	  elif [ "x$op1" == "x>f" ]; then
		if [ "x$tsChanged" == "xT"  ]; then
		  echo "update $dst/$file"
		  img_resize "$file"
		elif [ "x$tsChanged" == "x+" ]; then
		  echo "add $dst/$file"
		  img_resize "$file"
		fi
	  fi
	fi

done
