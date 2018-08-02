#!/bin/sh

echo "$(date +'%Y-%m/%d %H:%M:%S') - 10 - Trueno DietPi init start" >> /var/log/trueno-init.log
apt install -y usbmount >> /var/log/trueno-init.log
adduser admin          >> /var/log/trueno-init.log
adduser admin sudo     >> /var/log/trueno-init.log
adduser bitcoin        >> /var/log/trueno-init.log
adduser web            >> /var/log/trueno-init.log
apt install -y jq dphys-swapfile python xxd ufw >> /var/log/trueno-init.log

git

