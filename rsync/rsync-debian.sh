#/bin/bash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

RSYNCSOURCE=rsync://cdimage.debian.org/debian-cd/

BASEDIR=/var/www/html/mirror/iso/debian-cd

if [ ! -d ${BASEDIR} ]; then
  warn "${BASEDIR} does not exist yet, trying to create it..."
  mkdir -p ${BASEDIR} || fatal "Creation of ${BASEDIR} failed."
fi

rsync --verbose --recursive --times --links --safe-links --hard-links \
  --stats --delete-after --block-size=8192 --partial --exclude-from=ExcludeDebian.txt \
  ${RSYNCSOURCE} ${BASEDIR} || fatal "Failed to rsync from ${RSYNCSOURCE}."
# It excludes everything said in ExcludeDebian.txt (armel, mips, mips64el, mipsel, ppc64el, s390, s390x)