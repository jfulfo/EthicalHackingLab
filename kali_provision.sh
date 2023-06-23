#!/bin/bash

$KALI_PRIVATE_KEY=$1
$CLIENT_PUBLIC_KEY=$2

# Update and install packages
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-everything kali-desktop-xfce xrdp wireguard wireguard-tools
touch ~/.hushlogin

# Enable xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Write files
echo "xfce4-session" > ~/.xsession
sudo echo <<EOF
[Interface]
PrivateKey = $KALI_PRIVATE_KEY
Address = 10.1.10.1/24
ListenPort = 51820

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = 10.1.10.2/32
EOF > /etc/wireguard/wg0.conf

# Enable wireguard 
sudo systemctl enable wg-quick@wg0
sudo wg-quick up wg0


