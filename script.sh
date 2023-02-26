#!/bin/bash

path_log="/media/mand/LOG"
path_backup="/media/mand/BACKUP"
param=100
free_space=$((100 - $(df --output=pcent $path_log | tr -dc '0-9')))

echo -e "Hello, $(whoami)!\n"
if [ "$free_space" -le "$param" ]; then
	echo -e "There is not enough free space in the directory: less than $free_space% is left.\nYour data has been transferred to the archive at the following address: $path_backup.\n"
	cd $path_backup
	tar -czvf "$(date '+%Y-%m-%d_%H-%M').tar.gz" -C $path_log .
	rm -r $path_log$("/*")
	echo -e "\nSuccessfully! \n"
else 
	echo "You have enough space ($free_space%)."
fi 
