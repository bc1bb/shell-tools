#!/usr/bin/env bash
# Extremely simple script that makes a status page for wireguard
# Assumes that you have installed WG thru angristan's script
# https://github.com/angristan/wireguard-install
#
# "Why do I do it that way ?"
# - Because my VPN runs on a very low end server, and I don't want to install a CGI on it
# - so I'm just serving an html file this way

httproot="/var/www/html/index.html"
ok="/var/www/ok.html"
err="/var/www/err.html"
# Paths to HTML files that would define if Wireguard is running or not

sudo unlink "$httproot"

if systemctl is-active --quiet wg-quick@wg0; then
  sudo ln -s "$ok" "$httproot"
else
  sudo ln -s "$err" "$httproot"
fi
