# Ethical Hacking Course

## Requirements
Tested with:
- Terraform v1.5.0
- Packer v1.9.1
- Packer Chef Plugin v1.0.2
- Packer Azure Plugin v1.4.2
- Azure Cli v2.49.0

## Installation

You can clone the repository and run the scripts manually, or use the automated installation script.

This guide uses Ubuntu 22.04 LTS.

1. Update and install system packages:
    ```
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y net-tools openssh-server curl gnupg software-properties-common
    ```

2. Generate new SSH key (no passphrase):
    ```
    ssh-keygen
    ```

3. Clone EthicalHacking repository:
    ```
    git clone https://github.com/jfulfo/EthicalHacking
    cd EthicalHacking
    ```

4. Install Terraform:
    ```
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install terraform -y
    ```

5. Install Azure CLI:
    ```
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    az login
    ```

6. Setup Azure subscription:
    ```
    az account list --output table
    az account set --subscription "subscriptionId"
    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/subscriptionId"
    az vm image terms accept --urn kali-linux:kali:kali:latest
    ```

7. Add Azure subscription ID and client details to .bashrc (replace with actual values):
    ```
    export TF_VAR_ARM_SUBSCRIPTION_ID="subscriptionId"
    export PKR_VAR_ARM_SUBSCRIPTION_ID="subscriptionId"
    export PKR_VAR_ARM_CLIENT_ID="appId"
    export PKR_VAR_ARM_CLIENT_SECRET="password"
    export PKR_VAR_ARM_TENANT_ID="tenant"
    ```

8. Initialize Terraform and install Packer:
    ```
    source ~/.bashrc
    terraform init
    sudo apt install packer
    packer init ms3-linux.pkr.hcl
    ```

9. Install WireGuard and generate keys:
    ```
    sudo apt install wireguard -y
    umask 077
    wg genkey > privatekey
    wg pubkey < privatekey > publickey
    ```
10. Rename variables to unique name:
    ```
    variable "storage_account_name" {
      type = string
      default = "UniqueAccountName"
    }

    variable "storage_container_name" {
      type = string
      default = "UniqueContainerName"
    }

    variable "mssql_server_name" {
      type = string 
      default = "UniqueMSSQLName"
    }
    ```

11. Deploy infrastructure using Terraform:
    ```
    terraform plan
    terraform apply
    ```
12. Update WireGuard configuration file (wg0.conf):
    ```
    [Interface]
    PrivateKey = private_key
    Address = 10.1.10.2/24
    ListenPort = 51820

    [Peer]
    PublicKey = kali_public_key
    Endpoint = kali_public_ip:51820
    AllowedIPs = 10.0.0.0/8
    ```

13. Bring up VPN and establish SSH connection with Kali machine:
    ```
    sudo wg-quick up wg0.conf
    ssh kali@{kali_private_ip}
    ```

For more information and help, visit the book's [GitHub repository](https://github.com/Metasploit-Book/Setup-Scripts-Instructions).

## Potential Errors:

### `A Retryable Error Occured`
Delete the failed VM and its dependencies, then retry `terraform apply`.

## Contributors
- Daniel Graham
- Jake Fulford
