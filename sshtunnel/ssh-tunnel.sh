#!/bin/sh
# Create SSH Tunnel - Add on boot 

	echo "Opening SSH tunnel to ACS..."
	# Creating 1st process for ssh
		n=0
		until [ $n -ge 5 ]
		do
			ssh -fNL 2375:localhost:2375 -p 2200 azureuser@$(cat fqdn) -o StrictHostKeyChecking=no -o ServerAliveInterval=240 && echo "ACS SSH Tunnel successfully opened..." && break
			n=$((n+1)) && echo "Attempting to open ACS SSH tunnel again..."
			sleep 5
		done 

# first arg is `-f` or `--some-option`
	# if [ "${1#-}" != "$1" ]; then
	if [ "${1:0:1}" = '-' ]; then
		set -- docker "$@"
	fi

# if our command is a valid Docker subcommand, let's invoke it through Docker instead
# (this allows for "docker run docker ps", etc)
	if docker help "$1" > /dev/null 2>&1; then
		set -- docker "$@"
	fi

# Try user input docker command, if errors, try again up to 5 times
	n=0
   until [ $n -ge 5 ]
   do
      eval "$@" && exit 0
      n=$((n+1)) && echo "Docker daemon not ready. Trying $@ again..."
      sleep 5
   done 
wait	
exec "$@" 

# ssh output to nothing &>/dev/null