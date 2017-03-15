#!/bin/bash
#
# Run the create_vm_creds.sh script locally prior to running this file.

# Azure login
az login \
    --service-principal \
    -u $spn \
    -p $password \
    --tenant $tenant

# Group creation
az group create \
    -l $Location \
    -n $Resource
echo "Created Resource Group:" $rgname

# ACS Creation for Docker Swarm
az acs create \
    -g $Resource \
    -n $Dervicename \
    -d $Dnsprefix \
    --orchestrator-type $Orchestrator \
    --generate-ssh-keys \
    --verbose

# Grab the fully qualified domain name in an environment variable
fqdn=$Dnsprefix.$Location.cloudapp.azure.com

# Copy FQDN to host from container and to .gitignore
echo $fqdn > /deploy/fqdn
echo fqdn >> /deploy/.gitignore

# Copy Private Key to host from container and to .gitignore
cp /root/.ssh/id_rsa /deploy/id_rsa
echo id_rsa >> /deploy/.gitignore

# Confirm FQDN is captured and print to screen
echo "Your fully qualified domain name is $fqdn"