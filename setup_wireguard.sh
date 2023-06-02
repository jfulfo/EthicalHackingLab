#!/bin/bash

echo libssl1.1 libraries/restart-without-asking boolean true | sudo debconf-set-selections

# Install Wireguard
sudo add-apt-repository -y ppa:wireguard/wireguard
sudo apt-get update -y
sudo apt-get install -y wireguard

# Setup Wireguard configuration
echo "[Interface]
PrivateKey = iBUdYePICuKlZXWbO112wQZZLLKUHChHf9I6nViGel8=
Address = 10.0.0.1
ListenPort = 51820

[Peer]
PublicKey = 1Oxr7hXSprrwEka3x14QfKnwZc89dcmzPRGyTn1DGF0=
AllowedIPs = 10.0.0.2/32" | sudo tee /etc/wireguard/wg0.conf > /dev/null

# Enable Wireguard at startup
sudo systemctl enable wg-quick@wg0

# Start Wireguard
sudo systemctl start wg-quick@wg0

