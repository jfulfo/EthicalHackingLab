#!/bin/bash

echo libssl1.1 libraries/restart-without-asking boolean true | sudo debconf-set-selections

sudo apt update
sudo apt full-upgrade -y
sudo apt install kali-linux-default kali-linux-large -y
touch ~/.hushlogin
