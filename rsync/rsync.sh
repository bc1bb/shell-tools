#!/bin/bash

if [[ `id -u` -ne 0 ]] ; then echo "This file needs to be run as root" ; exit 1 ; fi

bash rsync-alpine.sh
bash rsync-debian.sh
bash rsync-lm.sh
bash rsync-ubuntu.sh

cd /var/www/html/mirror && du -sh > totalsize
echo -n $(sed 's/	.//' /var/www/html/mirror/totalsize) > /var/www/html/mirror/totalsize
echo -n "b" >> /var/www/html/mirror/totalsize
# This part makes file showing total size of the mirrors then make it easier to understand
# (because my index.php at beefs.tech shows this file so I wanted to make it easier to understand)

cd /var/www/html/ && du -h --max-depth=2 mirror/ > mirror/size
# I do `cd` before because it makes all the `size` file easier to read for a human
# Example :
#   - `size` w/o cd :
# 12K	/var/www/html/mirror/packages
# 22G	/var/www/html/mirror/iso/ubuntu-cd
# 302G	/var/www/html/mirror/iso/lm-cd
# 179G	/var/www/html/mirror/iso/debian-cd
# 640G	/var/www/html/mirror/iso/alpine-cd
# 1.2T	/var/www/html/mirror/iso
# 1.2T	/var/www/html/mirror/
#   - `size` w/ cd :
# 12K	mirror/packages
# 22G	mirror/iso/ubuntu-cd
# 302G	mirror/iso/lm-cd
# 179G	mirror/iso/debian-cd
# 640G	mirror/iso/alpine-cd
# 1.2T	mirror/iso
# 1.2T	mirror/
#
# You understand know ? :)

cd /var/www/html/ && du -h --max-depth=1 mirror/iso > mirror/iso/size

cd /var/www/html/ && du -h --max-depth=1 mirror/packages > mirror/packages/size

date -u > /var/www/html/mirror/trace
date -u > /var/www/html/mirror/iso/trace
date -u > /var/www/html/mirror/packages/trace
# add date of last sync in UTC format