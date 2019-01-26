echo "What is the domain ?"
read domainname

echo "What is the webroot ? (/var/www/...)"
read webroot

sudo certbot certonly --webroot -w "$webroot" -d "$domainname"
