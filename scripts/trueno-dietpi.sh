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

### 10: First step ###############################################################
if [ $state = 10 ]; then
  echo "*** init state: $state" >>$logFile 2>&1
  state=20
  echo "$state" > $stateFile
fi

### 20: Second step #############################################################
if [ $state = 20 ]; then
  echo "*** init state: $state" >>$logFile 2>&1
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow from 192.168.0.0/24 to any port 22 comment 'allow SSH from local LAN'
  ufw allow from 192.168.0.0/24 to any port 50002 comment 'allow Electrum from local LAN'
  ufw allow 9735  comment 'allow Lightning'
  ufw allow 8333  comment 'allow Bitcoin mainnet'
  ufw allow 18333 comment 'allow Bitcoin testnet'
  echo "y" | ufw enable
  systemctl enable ufw
  
  state=30
  echo "$state" > $stateFile
fi
