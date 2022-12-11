#!/bin/bash

set -e

# ensure unicode filenames are supported
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export G_FILENAME_ENCODING="@locale"
export G_BROKEN_FILENAMES="1"

function usage() {
    echo "Usage: mirror.sh [OPTIONS]"
    echo "   OPTIONS includes:"
    echo "   -x | --dry-run - do not copy only files, only echo what will be done. default mode"
    echo "   -m | --mirror - copy files from src to dest. overrides dry run"
    echo "   -s | --src  - source directory"
    echo "   -d | --dest - destination directory"
    echo "   -h | --help - displays this message"
}

run_type="dry-run"
while [ "$1" != "" ]
do
  case $1 in
    -x | --dry-run )
        run_type="dry-run"
        ;;
    -m | --mirror )
        run_type="mirror"
        ;;
    -s | --src )
        shift
        if [ -d "$1" ]; then
          src="${1%/}"  # source without trailing slash
        else
          echo "$0: $1 is not a valid directory" >&2
          exit
        fi
        ;;
    -d | --dest )
        shift
        dest="${1%/}" # dest without trailing slash
        ;;
    -h | --help ) 
        usage
        exit 0
        ;;
    * ) 
        echo "Invalid option: $1"
        usage
        exit 1
        ;;
  esac
  shift
done

function ensure_vars() {
  for v in "$@"
  do
    if [ -z "${!v}" ]; then 
      echo "ERROR: $v is not specified"
      usage
      exit 1
    fi
  done
}

ensure_vars "run_type" "src" "dest"

function log() {
    echo "$(date +'%Y-%m-%d %T'): $1"
}

function exec_cmd() {
  if [ "${run_type}" == "dry-run" ]; then
    echo "dry-run: $@"
  elif [ "${run_type}" == "mirror" ]; then
    "$@"
  else
    echo "warning: unknown run type ${run_type}"
    exit 2
  fi
}

log "run mode: $run_mode"
log "sync $src => $dest"
log "-----------------------------------------------"

rsync --dry-run --recursive --itemize-changes --delete --delete-excluded --iconv=utf-8 \
	--exclude '@eaDir' --exclude 'Thumbs.db' "$src" "$dest" | while read -r line ; do
    echo "$line"
    read -r op file <<< "$line"
    log "from $file"

    if [ "x$op" == "x*deleting" ]; then
      log "removing $dest/$file"
      exec_cmd rm -rf "$dest/$file"
    else
      op1=$(echo $op | cut -b 1-2)
      sizeTsState=$(echo $op | cut -b 4-5)
      src_file="$(dirname $src)/$file"

      if [ "x$op1" == "xcd" ]; then
	      log "not eagerly creating $dest/$file"
      elif [ "x$op1" == "x>f" ]; then
        dest_file="$dest/$file"
        dest_dir=$(dirname "${dest_file}")
        if [ "x$sizeTsState" == "x.T"  ]; then
          log "update ${dest_file} timestamp only"
          exec_cmd touch -r "${src_file}" "${dest_file}"
        elif [ "x$sizeTsState" != "x.."  ]; then
          if [ ! -d "${dest_dir}" ]; then
            exec_cmd sudo -u nobody mkdir -v -m 777 -p "${dest_dir}"
          fi
          exec_cmd install -o nobody -g users -m 666 -p -D -v "${src_file}" "${dest_file}"
        fi
      fi
    fi
done
