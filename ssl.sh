echo "What do you want to do ?"
echo ""
echo "renew - To renew SSL certificates"
echo "create - To create SSL certificates"
echo ""
read whattodo

createssl() {
    echo "What is the domain ?"
    read domainname

    echo "Does it have an alias ? (y/n)"
    read ynalias

    if [ "$ynalias" = "y" ] || [ "$ynalias" = "Y" ] || [ "$ynalias" = "yes" ] || [ "$ynalias" = "Yes" ]; then
          echo "What is it ?"
          read domainalias
    else
          domainalias=false
    fi

    echo "What is the webroot ? (/var/www/...)"
    read webroot

    if [ ! "$domainalias" = "false" ]; then
          sudo certbot certonly -n --webroot -w "$webroot" -d "$domainname" -d "$domainalias"
    else
          sudo certbot certonly -n --webroot -w "$webroot" -d "$domainname"
    fi
}
renewssl() {
    echo "Renewing SSL cert"
    sudo certbot -n renew
}

if [ "$whattodo" = "create" ]; then
    createssl
fi; if [ "$whattodo" = "renew" ]; then
    renewssl
fi
