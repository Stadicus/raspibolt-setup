#!/bin/sh
# RaspiBolt: init script for DietPi automation

baseDir="/opt/trueno"
logDir="$baseDir/log"
logFile="$logDir/init.log"
stateFile="$baseDir/init.state"

# How far in the init process? --> get init state
if [ -f "$stateFile" ]; then
  state=$( cat $stateFile )
else
  state=10
fi
echo "" > $logFile
mkdir -p $logDir
{
	echo "*** $(date +'%Y-%m/%d %H:%M:%S') - INIT - state: $state"

	### 10: Get source files
	if [ $state = 10 ]; then
		rm -rf $baseDir/src
		git clone https://github.com/Stadicus/raspibolt-setup $baseDir/src 
		chmod +x $baseDir/src/scripts/*
		cp $baseDir/src/scripts/* /usr/local/bin

		# do not overwrite existing config
		if [ ! -d "$baseDir/config" ]; then
			cp -R $baseDir/src/config $baseDir
		fi
		
		# start autoinit on root login (prevent double entries)
		(grep -vE "(raspibolt-autoinit)" /root/.bashrc; echo "/usr/local/bin/raspibolt-autoinit.sh") >> /root/.bashrc_tmp
		mv /root/.bashrc_tmp /root/.bashrc
		dietpi-autostart 7

		adduser admin --gecos "" --disabled-password
		adduser admin sudo
		adduser bitcoin --gecos "" --disabled-password
		adduser display --gecos "" --disabled-password
		adduser web --gecos "" --disabled-password

		state=20
		echo "$state" > $stateFile
	fi

	### 20: Prepare Linux 
	if [ $state = 20 ]; then
		echo "*** $(date +'%Y-%m/%d %H:%M:%S') - INIT - state: $state"
		apt-get install -y usbmount jq dphys-swapfile python python3 python-pip xxd ufw
		pip install docker-compose

		# Copy all system files to the base filesystem
		cp -R $baseDir/src/fs/* /

		# Set Uncomplicated Firewall (UFW)
		ufw default deny incoming
		ufw default allow outgoing
		ufw allow 22    comment 'allow SSH'
		ufw allow 8333  comment 'allow Bitcoin mainnet'
		ufw allow 18333 comment 'allow Bitcoin testnet'
		ufw allow 9735  comment 'allow Lightning'
		ufw allow 50002 comment 'allow Electrum'
		echo "y" | ufw enable
		systemctl enable ufw
	fi
	
	### 30: Build docker
	if [ $state = 30 ]; then
		echo "*** $(date +'%Y-%m/%d %H:%M:%S') - INIT - state: $state"
		echo "Build Docker!"
	
	fi
} 2>&1 | tee $logFile 
