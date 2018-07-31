#!/bin/sh

echo "$(date +'%Y-%m/%d %H:%M:%S') - 10 - init start" >> /home/pi/init.log
echo "10" > /home/pi/init.status
sleep 30

if [ -f "/home/pi/init.status" ]; then
  initState=$( cat /home/pi/init.status )
  echo "init state: $initState" >> /home/pi/init.log
else
  initState=0
fi

# create users 
if ! id "displayuser" >/dev/null 2>&1; then
  echo "add user 'displayuser'" >> /home/pi/init.log
  adduser displayuser --gecos "" --disabled-password >>/home/pi/init.log 2>&1
fi

if ! id "bitcoin" >/dev/null 2>&1; then
  echo "add user 'bitcoin'" >> /home/pi/init.log
  adduser bitcoin --gecos "" --disabled-password >>/home/pi/init.log 2>&1
fi

if ! id "web" >/dev/null 2>&1; then
  echo "add user 'web'" >> /home/pi/init.log
  adduser web --gecos "" --disabled-password >>/home/pi/init.log 2>&1
fi

# echo "*** Update System ***"
apt-mark hold raspberrypi-bootloader  >>/home/pi/init.log 2>&1
apt-get update  >>/home/pi/init.log 2>&1
apt-get upgrade -f -y --force-yes >>/home/pi/init.log 2>&1
dpkg --configure -a >>/home/pi/init.log 2>&1

# install setup scripts
apt install git -y >>/home/pi/init.log 2>&1
rm -rf /home/pi/setup
git clone -b initial https://github.com/Stadicus/raspibolt-setup /home/pi/setup
cp /home/pi/setup/scripts/sbin/* /usr/local/sbin/
chmod +x /usr/local/sbin/trueno*.sh

if ! grep -q install.sh /home/pi/.profile; then
  echo "/usr/local/sbin/trueno-2-install.sh" >> /home/pi/.profile
fi

chown pi:pi -R /home/pi
chown web:web -R /home/web

# enable display
if ! grep -q fbcon /boot/cmdline.txt; then
  #echo "fbcon=map:10 fbcon=font:VGA8x8" >>  /boot/cmdline.txt
fi
if ! grep -q dtoverlay /boot/config.txt; then
  #echo "dtoverlay=piscreen,speed=16000000,rotate=270" >> /boot/config.txt
fi

fbcon=map:10 fbcon=font:VGA8x8


echo "20" > /home/pi/init.status
