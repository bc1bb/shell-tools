echo "[START] Backup started on $(date)" > backup.log
echo "Starting backup"

if [ ! "$(whoami)" = "root" ]; then
     echo "[ERROR] Execute as Super User"
     echo "[END] Backup failed on $(date)" >> backup.log
     exit 1
fi

echo "[mkdir] Creating required folders"
mkdir ~/backup &>~/backup.log
mkdir ~/backup/{letsencrypt,a2vhost,a2files,apt,ts,etc} &>>~/backup.log

echo "[cp] Backuping Let's Encrypt certificates"
cp -R /etc/letsencrypt/live/* ~/backup/letsencrypt &>>~/backup.log

echo "[cp] Backuping Apache2 vhost configuration"
cp -R /etc/apache2/sites-available/* ~/backup/a2vhost &>>~/backup.log

echo "[cp] Backuping Apache2 files"
cp -R /var/www/* ~/backup/a2files &>>~/backup.log

echo "[tar] Compressing Apache2 files"
cd ~/backup/ && tar -cvpJf a2files.tar.xz ~/backup/a2files/ &>>~/backup.log
rm -R ~/backup/a2files/ &>>~/backup.log

echo "[cp] Backuping /etc"
cp -R /etc/* ~/backup/etc  &>>~/backup.log

echo "[tar] Compressing /etc"
cd ~/backup/ && tar -cvpJf etc.tar.xz ~/backup/etc/ &>>~/backup.log
rm -R ~/backup/etc/ &>>~/backup.log

echo "[apt] Backuping software installed thru APT"
apt list 2>>~/backup.log | grep "installed" > ~/backup/apt/installed

echo "[cp] Backuping TeamSpeak3 files"
cp -R ~teamspeak/* ~/backup/ts/ &>>~/backup.log

echo "[mysqldump] Backuping MySQL databases"
su backup -c "mysqldump -A -Y -C -f -u backup" > ~/backup/mariadb.sql 2>>~/backup.log

echo "[tar] Compressing backup"
cd ~ && sudo tar -cvpJf backup.tar.xz ~/backup &>>~/backup.log
rm -r ~/backup &>>~/backup.log

echo "[mv] Putting backup on Nextcloud"
rm /var/www/nextcloud/data/jusdepatate/files/backup.tar.xz
mv ~/backup.tar.xz /var/www/nextcloud/data/jusdepatate/files/backup.tar.xz

echo "[info] Backup log in file backup.log"
echo "End of Backup"

echo "[END] Backup ended on $(date)" >> ~/backup.log
exit 0
