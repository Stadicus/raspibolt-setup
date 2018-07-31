#!/bin/sh

echo "$(date +'%Y-%m/%d %H:%M:%S') - init start" >> /home/pi/init.log

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
apt install git -y >>/home/pi/init.log 2>&1

chown pi:pi -R /home/pi
chown web:web -R /home/web
