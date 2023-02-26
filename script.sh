#!/bin/bash
echo "Hello, $(whoami)!"
param=70
free_space=$(( 100 - $(df --output=pcent /media/mand/LOG | tr -dc '0-9') ))
echo -e "Free space: $free_space%\n" 
if [ "$free_space" -le "$param" ]; then
	echo "You have $free_space%!"
	cd /media/mand/BACKUP
	tar -czvf "$(date '+%Y-%m-%d_%H-%M').tar.gz" -C /media/mand/LOG .
	rm -r /media/mand/LOG/*
else 
	echo "You have enough space"
fi 
