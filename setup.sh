#!/bin/bash

# Update and install packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y net-tools openssh-server curl gnupg software-properties-common

# generate ssh key with no passphrase
read -p "Do you want to overwrite the existing ssh key (~/.ssh/id_rsa)? (Y/n): " OVERWRITE
if [[ $OVERWRITE == "n" ]]; then
    exit 1
fi 
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N "" <<< y >/dev/null 2>&1

# install terraform (from docs)
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

# install azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login 

az account list --output table
read -p "Enter the subscription id you want to use (must be pay as you go or high enough quota): " TF_VAR_ARM_SUBSCRIPTION_ID
az account set --subscription $TF_VAR_ARM_SUBSCRIPTION_ID
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$TF_VAR_ARM_SUBSCRIPTION_ID"
# read client id, client secret, and tenant id from output and export to bashrc
read -p "Enter the client id (appId): " PKR_VAR_ARM_CLIENT_ID
read -p "Enter the client secret (password): " PKR_VAR_ARM_CLIENT_SECRET
read -p "Enter the tenant id (tenant): " PKR_VAR_ARM_TENANT_ID
az vm image terms accept --urn kali-linux:kali:kali:latest

# export variables to bashrc
echo "Adding variables to ~/.bashrc..."
export TF_VAR_ARM_SUBSCRIPTION_ID=$TF_VAR_ARM_SUBSCRIPTION_ID
export PKR_VAR_ARM_SUBSCRIPTION_ID=$TF_VAR_ARM_SUBSCRIPTION_ID
export PKR_VAR_ARM_CLIENT_ID=$PKR_VAR_ARM_CLIENT_ID
export PKR_VAR_ARM_CLIENT_SECRET=$PKR_VAR_ARM_CLIENT_SECRET
export PKR_VAR_ARM_TENANT_ID=$PKR_VAR_ARM_TENANT_ID
echo "export TF_VAR_ARM_SUBSCRIPTION_ID=$TF_VAR_ARM_SUBSCRIPTION_ID" >> ~/.bashrc
echo "export PKR_VAR_ARM_SUBSCRIPTION_ID=$TF_VAR_ARM_SUBSCRIPTION_ID" >> ~/.bashrc
echo "export PKR_VAR_ARM_CLIENT_ID=$PKR_VAR_ARM_CLIENT_ID" >> ~/.bashrc 
echo "export PKR_VAR_ARM_CLIENT_SECRET=$PKR_VAR_ARM_CLIENT_SECRET" >> ~/.bashrc 
echo "export PKR_VAR_ARM_TENANT_ID=$PKR_VAR_ARM_TENANT_ID" >> ~/.bashrc 

# initialize terraform and packer
terraform init 
sudo apt install packer -y 
packer init ms3-linux.pkr.hcl 
packer init ms3-windows.pkr.hcl

# install wireguard and generate keys
sudo apt install wireguard -y 
umask 077
wg genkey > privatekey 
wg pubkey < privatekey > publickey

echo "We will now run terraform to create the VMs. This will take a ~25 minutes"
read -p "Continue? (Y/n): " CONTINUE
if [[ $CONTINUE == "n" ]]; then
    exit 1
fi
terraform apply -auto-approve
terraform output

# get local privatekey
PRIVATE_KEY=$(cat privatekey)
read -p "Enter the public IP of the Kali VM: " KALI_IP
read -p "Eneter the public key of the Kali VM: " KALI_PUBLIC_KEY

# create wireguard config
sudo tee /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.1.10.2/24
ListenPort = 51820

[Peer]
PublicKey = $KALI_PUBLIC_KEY
Endpoint = $KALI_IP:51820
AllowedIPs = 10.0.0.0/8
EOF

# enable wireguard
sudo wg-quick up wg0

echo "Setup complete"
echo "You can now connect to the Kali VM using the following command: ssh kali@$KALI_IP"

