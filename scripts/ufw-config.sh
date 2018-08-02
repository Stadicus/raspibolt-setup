#!/bin/sh
# configuration for Uncompliated Firewall

ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.0.0/24 to any port 22 comment 'allow SSH from local LAN'
ufw allow from 192.168.0.0/24 to any port 50002 comment 'allow Electrum from local LAN'
ufw allow 9735  comment 'allow Lightning'
ufw allow 8333  comment 'allow Bitcoin mainnet'
ufw allow 18333 comment 'allow Bitcoin testnet'

echo "y" | ufw enable
systemctl enable ufw
