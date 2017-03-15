#!/bin/bash
#
# Run this script LOCALLY before any other script, run by typing ./serviceprincipal.sh id password role
# To view the available roles, see https://docs.microsoft.com/azure/active-directory/role-based-access-built-in-roles Default recommended is Contributor, which can manage everything except access

# Positional Parameters
name="$1"
password="$2" 
role="$3"

# Login - Complete this process using a browser
az login

# Capture tenant ID
tenant=$(az account show | jq -r '.tenantId')

# Begin AD Service Principal Creation 
az ad sp create-for-rbac \
    -n $name \
    --password \
    $password \
    --role $role \
    --verbose

# Output service principal
echo "Successfully created Service Principal."
echo "==============Created Serivce Principal=============="
echo "spn=http://$name" 
echo "password=$password"
echo "tenant=$tenant"

# Copy service principal to environment variables file
echo '# azure serivce principal auth
spn='$spn'
password='$password'
tenant='$tenant'
' > azure.env
echo "azure.env created"

# Add azure.env to .gitignore
echo "azure.env" >> .gitignore
echo "azure.env copied to .gitignore"

# Encrypt azure.env using CodeShip Jet
# jet encrypt [--key-path=codeship.aes] plain_file encrypted_file
jet encrypt azure.env azure.env.encrypted
