echo "[START] Backup started on $(date)" > backup.log
echo "Starting backup"

if [ ! "$(whoami)" = "root" ]; then
 echo "[ERROR] Execute as Super User"
 echo "[END] Backup failed on $(date)" >> backup.log
 exit 1
fi

echo "[mkdir] Creating required folders"
mkdir ~/backup 2>>~/backup.log
mkdir ~/backup/{a2files,apt,etc,minecraft} 2>>~/backup.log

echo "[cp] Backuping Apache2 files"
cp -R /var/www/* ~/backup/a2files 2>>~/backup.log

echo "[cp] Backuping /etc"
cp -R /etc/* ~/backup/etc  2>>~/backup.log

echo "[apt] Backuping software installed thru APT"
apt list 2>>~/backup.log | grep "installed" > ~/backup/apt/installed

#echo "[cp] Backuping TeamSpeak3 files"
#cp -R ~teamspeak/* ~/backup/ts/ 2>>~/backup.log

echo "[mysqldump] Backuping MySQL databases"
su backup -c "mysqldump -A -Y -C -f -u backup" > ~/backup/mariadb.sql 2>>~/backup.log

#echo "[cp] Backuping MC"
#cp -R ~root/minecraft/* ~/backup/minecraft/ 2>>~/backup.log

echo "[tar] Compressing backup"
cd ~ && sudo tar -cvpJf backup.tar.xz ~/backup 2>>~/backup.log
rm -r ~/backup &>>~/backup.log

#echo "[mv] Putting backup on Nextcloud"
#rm /var/www/nextcloud/data/jusdepatate/files/backup.tar.xz
#mv ~/backup.tar.xz /var/www/nextcloud/data/jusdepatate/files/backup.tar.xz

echo "[info] Backup log in file ~/backup.log"
echo "[info] Backup is in file backup.tar.xz"
echo "End of Backup"

echo "[END] Backup ended on $(date)" >> ~/backup.log
exit 0
