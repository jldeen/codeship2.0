#!/bin/bash
#
# Run the create_vm_creds.sh script locally prior to running this file.

# Azure login
az login \
    --service-principal \
    -u $spn \
    -p $password \
    --tenant $tenant

# Azure variables
rgname="JDTest"
servicename="ACSJDDemo"
orchestrator="Swarm" #other options include kubernetes and dcos
dnsprefix="jdacs2"
loc="centralus"

# Group creation
az group create \
    -l $loc \
    -n $rgname
echo "Created Resource Group:" $rgname

# ACS Creation for Docker Swarm
az acs create \
    -g $rgname \
    -n $servicename \
    -d $dnsprefix \
    --orchestrator-type $orchestrator \
    --generate-ssh-keys \
    --verbose


# Grab the fully qualified domain name in an environment variable
fqdn=$dnsprefix.$loc.cloudapp.azure.com

# Copy FQDN to host from container and to .gitignore
echo $fqdn > /deploy/fqdn
echo fqdn >> /deploy/.gitignore

# Copy Private Key to host from container and to .gitignore
cp /root/.ssh/id_rsa
echo id_rsa >> /deploy/.gitignore

# Confirm FQDN is captured and print to screen
echo "Your fully qualified domain name is $fqdn"