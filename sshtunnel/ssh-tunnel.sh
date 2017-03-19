#!/bin/sh
# Create SSH Tunnel - Add on boot 
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- docker "$@"
fi

# # If the user is trying to run Vault directly with some arguments, then
# # pass them to Docker.
# if [ "${1:0:1}" = '-' ]; then
#     set -- docker "$@"
# fi

# if our command is a valid Docker subcommand, let's invoke it through Docker instead
# (this allows for "docker run docker ps", etc)
if docker help "$1" > /dev/null 2>&1; then
	set -- docker "$@"
fi

ssh -fNL 2375:localhost:2375 -p 2200 azureuser@$(cat fqdn) -o StrictHostKeyChecking=no -o ServerAliveInterval=240 
# &>/dev/null

exec "$@"