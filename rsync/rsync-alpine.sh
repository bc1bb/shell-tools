#/bin/bash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://rsync.alpinelinux.org/alpine

BASEDIR=/var/www/html/mirror/iso/alpine-cd

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

rsync -az --verbose --recursive --times --links --safe-links --hard-links \
  --stats --delete-after --delete-excluded --block-size=8192 --partial \
  ${RSYNCSOURCE} ${BASEDIR} || fatal "Failed to rsync from ${RSYNCSOURCE}."