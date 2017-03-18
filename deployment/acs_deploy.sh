#!/bin/bash
#
# Run the create_vm_creds.sh script locally prior to running this file.

#login
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

    echo "Beginning Azure Container Service creation now. Please note this can take more than 10 minutes to complete."
# ACS Creation for Docker Swarm
    az acs create \
        -g $Resource \
        -n $Servicename \
        -d $Dnsprefix \
        --orchestrator-type $Orchestrator \
        --generate-ssh-keys \
        --verbose

# Grab the fully qualified domain name in an environment variable
    fqdn=$(az acs show -n $Servicename -g $Resource | jq -r '.masterProfile | .fqdn')

# Copy FQDN to host from container and to .gitignore
    echo $(az acs show -n $Servicename -g $Resource | jq -r '.masterProfile | .fqdn') > /deploy/fqdn
    echo fqdn >> /deploy/.gitignore

# Copy Private Key to host from container and to .gitignore
    cp /root/.ssh/id_rsa /deploy/id_rsa
    echo id_rsa >> /deploy/.gitignore

# Confirm FQDN is captured and print to screen
    echo "Your fully qualified domain name is $fqdn"
# Outputs
    # Code to capture ACS agents info
        az acs show -n $Servicename -g $Resource | jq -r '.agentPoolProfiles[0].fqdn'
        agents_fqdn=$(az acs show -n $Servicename -g $Resource | jq -r '.agentPoolProfiles[0].fqdn')

    # Code to capture ACS master info
        az acs show -n $Servicename -g $Resource | jq -r jq -r '.masterProfile | .fqdn'

    # Set ssh connection string
        master_fqdn=$(az acs show -n ACSJDDemo -g Codeshipaz2 | jq -r '.masterProfile.fqdn')
        admin_username=$(az acs show -n ACSJDDemo -g Codeshipaz2 | jq -r '.linuxProfile.adminUsername')

    # Print results 
        echo "------------------------------------------------------------------"
        echo "Important information"
        echo "SSH Connection String: ssh $admin_username@$master_fqdn -A -p 2200"
        echo "Master FQDN: $master_fqdn"
        echo "Agents FQDN: $agents_fqdn"
        echo "Your web applications can be viewed at $agents_fqdn."
        echo "------------------------------------------------------------------"