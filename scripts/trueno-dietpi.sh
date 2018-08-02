#!/bin/sh

stateFile="/root/init.state"
logFile="/var/log/trueno-init.log"

echo "*** $(date +'%Y-%m/%d %H:%M:%S') - Trueno DietPi init start" >>$logFile 2>&1
adduser admin --gecos "" --disabled-password >>$logFile 2>&1
adduser admin sudo >>$logFile 2>&1
adduser bitcoin --gecos "" --disabled-password >>$logFile 2>&1
adduser web --gecos "" --disabled-password >>$logFile 2>&1

apt-get install -y usbmount jq dphys-swapfile python python3 xxd ufw >>$logFile 2>&1

if [ -d "/root/raspibolt-setup" ]; then
  cd raspibolt-setup
  git pull >>$logFile 2>&1
  cd
else
  git clone https://github.com/Stadicus/raspibolt-setup >>$logFile 2>&1
fi
cp -R raspibolt-setup/fs/* / >>$logFile 2>&1

if [ -f "$stateFile" ]; then
  state=$( cat $stateFile )
else
  state=10
  echo "$state" > $stateFile
fi

if [ $state = 10 ]; then
  echo "*** init state: $state" >>$logFile 2>&1
  state=20
  echo "$state" > $stateFile
fi

if [ $state = 20 ]; then
  echo "*** init state: $state" >>$logFile 2>&1
  state=30
  echo "$state" > $stateFile
fi
