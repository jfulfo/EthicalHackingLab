# Ethical Hacking Course

## Requirements
Tested with:
- Terraform v1.5.0
- Packer v1.9.1
- Packer Chef Plugin v1.0.2
- Packer Azure Plugin v1.4.2
- Azure Cli v2.49.0

## Installation

This guide uses Ubuntu 22.04 LTS.

1. Update system packages:
    ```
    sudo apt update
    sudo apt upgrade -y
    ```

2. Install required packages:
    ```
    sudo apt install -y net-tools openssh-server git curl
    ```

3. Generate new SSH key (no passphrase):
    ```
    ssh-keygen
    ```

4. Clone EthicalHacking repository:
    ```
    git clone https://github.com/jfulfo/EthicalHacking
    cd EthicalHacking
    ```

5. Install Terraform required packages:
    ```
    sudo apt install gnupg software-properties-common -y
    ```

6. Install Terraform:
    ```
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install terraform -y
    ```

7. Install Azure CLI:
    ```
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    az login
    ```

8. Setup Azure subscription:
    ```
    az account list --output table
    az account set --subscription "subscriptionId"
    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/subscriptionId"
    az vm image terms accept --urn kali-linux:kali:kali:latest
    ```

9. Add Azure subscription ID and client details to .bashrc (replace with actual values):
    ```
    export TF_VAR_ARM_SUBSCRIPTION_ID="subscriptionId"
    export PKR_VAR_ARM_CLIENT_ID="appId"
    export PKR_VAR_ARM_CLIENT_SECRET="password"
    export PKR_VAR_ARM_TENANT_ID="tenant"
    ```

10. Initialize Terraform and install Packer:
    ```
    source ~/.bashrc
    terraform init
    sudo apt install packer
    ```

11. Install WireGuard and generate keys:
    ```
    sudo apt install wireguard -y
    umask 077
    wg genkey > privatekey
    wg pubkey < privatekey > publickey
    ```

12. Deploy infrastructure using Terraform:
    ```
    terraform plan
    terraform apply
    ```

13. Update WireGuard configuration file (wg0.conf):
    ```
    [Interface]
    PrivateKey = private_key
    Address = 10.1.10.2/24
    ListenPort = 51820

    [Peer]
    PublicKey = kali_public_key
    Endpoint = kali_public_ip:51820
    AllowedIPs = 0.0.0.0/0, ::/0
    ```

14. Bring up VPN and establish SSH connection with Kali machine:
    ```
    sudo wg-quick up wg0.conf
    ssh kali@{kali_private_ip}
    ```

For more information and help, visit [GitHub repository](https://github.com/Metasploit-Book/Setup-Scripts-Instructions).

## Contributors
- Daniel Graham
- Jake Fulford
