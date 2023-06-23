#!/bin/bash

ACCOUNT_NAME=$1
CONTAINER_NAME=$2

zip -r scripts.zip scripts
zip -r resources.zip resources
az storage blob upload --account-name $ACCOUNT_NAME --name scripts.zip --type block --file scripts.zip --container-name $CONTAINER_NAME --overwrite
az storage blob upload --account-name $ACCOUNT_NAME --name resources.zip --type block --file resources.zip --container-name $CONTAINER_NAME --overwrite
az storage blob upload --account-name $ACCOUNT_NAME --name ms3_windows_provision.ps1 --type block --file ms3_windows_provision.ps1 --container-name $CONTAINER_NAME --overwrite
