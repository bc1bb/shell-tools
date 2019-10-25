#/bin/bash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://pub.linuxmint.com/pub/

BASEDIR=/var/www/html/mirror/iso/lm-cd

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} or ${OLDBASEDIR} does not exist yet, trying to create them..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

rsync --verbose --recursive --times --links --safe-links --hard-links \
  --stats --delete-after \
  ${RSYNCSOURCE} ${BASEDIR} || fatal "Failed to rsync from ${RSYNCSOURCE}."
