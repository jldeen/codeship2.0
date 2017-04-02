#!/bin/sh

# Login into azure using SPN
	if [ az account show &>/dev/null ]; then
		echo "You are already logged in to Azure..."
	else
		echo "Logging into Azure..."
			az login \
				--service-principal \
				-u $spn \
				-p $password \
				--tenant $tenant &>/dev/null
			echo "Successfully logged into Azure..."
	fi

	# Code to capture ACS master info
        master_fqdn=$(az acs show -n $Servicename -g $Resource | jq -r '.masterProfile | .fqdn')
        echo "Successfully captured your Master FQDN: $master_fqdn" 

# Check if K8 and setup Kubectl
	az acs kubernetes install-cli
	az acs kubernetes get-credentials --resource-group=$Resource --name=$Servicename
	echo "Successfully installed Kubectl" 
