# Shell Tools
## backup.sh
```
root@jdp:~$ ./bck.sh
Starting backup
[mkdir] Creating required folders
[cp] Backuping Let's Encrypt certificates
[cp] Backuping Apache2 vhost configuration
[cp] Backuping Apache2 files
[tar] Compressing Apache2 files
[cp] Backuping /etc
[tar] Compressing /etc
[apt] Backuping software installed thru APT
[cp] Backuping TeamSpeak3 files
[mysqldump] Backuping MySQL databases
[tar] Compressing backup
[mv] Putting backup on Nextcloud
[info] Backup log in file backup.log
End of Backup
```
**+ don't forget to check `backup.log`**

## ssl.sh
```
What do you want to do ?

renew - To renew SSL certificates
create - To create SSL certificates

create
What is the domain ?
jusdepatate.fr
Does it have an alias ? (y/n)
y
What is it ?
www.jusdepatate.fr
What is the webroot ? (/var/www/...)
/var/www/jusdepatate
[sudo] password for jusdepatate:
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator webroot, Installer None
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for nextcloud.jusdepatate.fr
Using the webroot path /var/www/nextcloud for all unmatched domains.
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/nextcloud.jusdepatate.fr/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/nextcloud.jusdepatate.fr/privkey.pem
   Your cert will expire on 2019-04-26. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```
