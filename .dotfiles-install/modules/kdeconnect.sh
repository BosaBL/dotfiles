#!/usr/bin/env bash

installPackage "kde-connect"

# Enable firewall rules
echo "Enabling firewall rules for KDE Connect"

sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --reload
