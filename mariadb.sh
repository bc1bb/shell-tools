#!/usr/bin/env bash

if [ ! "$(whoami)" = "root" ]; then
    echo "execute as root"
    exit 1
fi
echo "What do you want to do ?"
echo ""
echo "createuser - Create a user [with a db]"
echo "createroot - Create a root-like user"
echo "deleteuser - Delete user"
echo "listuser - List all users"
echo "createdb - Create a db"
echo "deletedb - Delete a db"
echo "listdb - List all db"
echo ""

read whattodo
echo ""

if [ "$whattodo" = "createuser" ]; then
    printf "What is the name of the user ? " && read username
    printf "What is the password of the user ? " && read password
    printf "Do you want a db with the user ? (y/n) " && read yndb
    if [ "$yndb" = "y" ]; then mysql -e "CREATE USER $username@'localhost' IDENTIFIED BY '$password'; CREATE DATABASE IF NOT EXISTS $username; GRANT ALL PRIVILEGES ON $username.* TO $username@'localhost';FLUSH PRIVILEGES;"
    else mysql -e "CREATE USER $username@'localhost' IDENTIFIED BY '$password';"; fi
elif [ "$whattodo" = "createroot" ]; then
    printf "What is the name of the root-like user ? " && read username
    printf "What is the password of the user ? " && read password
    mysql -e "CREATE USER $username@'localhost' IDENTIFIED BY '$password';GRANT ALL PRIVILEGES ON  *.* to $username@'localhost' WITH GRANT OPTION;FLUSH PRIVILEGES;"
elif [ "$whattodo" = "deleteuser" ]; then
    printf "What is the name of the user to be deleted ? " && read username
    mysql -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM $username@'localhost';DROP USER IF EXISTS $username;"
elif [ "$whattodo" = "listuser" ]; then
    mysql -e "SELECT User FROM mysql.user;"
elif [ "$whattodo" = "createdb" ]; then
    printf "What is the name of the db ? " && read db
    mysql -e "CREATE DATABASE IF NOT EXISTS '$db';"
elif [ "$whattodo" = "deletedb" ]; then
    printf "What is the name of the db to be deleted ? " && read db
    mysql -e "DROP DATABASE $db;"
elif [ "$whattodo" = "listdb" ]; then
    mysql -e "SHOW DATABASES;"
else
    echo "u tried"
    exit 1
fi
