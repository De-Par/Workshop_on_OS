#!/bin/bash

PATH_LOG="/media/mand/LOG/"
PATH_BACKUP="/media/mand/BACKUP/"
FREE_SPACE_PARAM=70

echo -e "\n - Hello, $(whoami)!\n"

if [ ! -d $PATH_LOG ]; then
	echo -e " - Your directory at the following adress (\"$PATH_LOG\") does not exists!\n"
	exit 0
elif [ ! -d $PATH_BACKUP ]; then
	echo -e " - Your directory at the following adress (\"$PATH_BACKUP\") does not exists!\n"
	exit 0
fi

FREE_SPACE_LOG=$((100 - $(df --output=pcent $PATH_LOG | tr -dc '0-9')))
FREE_SPACE_BACK=$((100 - $(df --output=pcent $PATH_BACKUP | tr -dc '0-9')))

#if [ "$FREE_SPACE_BACK" -le "$FREE_SPACE_LOG" ]; then
#	echo -e " - Free up space in the BACKUP at the following adress (\"$PATH_BACKUP\"), as it may not fit all the data!\n"
#	exit 0
	
if [ "$FREE_SPACE_LOG" -le "$FREE_SPACE_PARAM" ]; then
	echo -e " - There is not enough free space in the directory: less than $FREE_SPACE_LOG% free memory.\n"
	read -p " - Archive all data (y) or selectively (n)? [y/n]: " FLAG
	
	cd $PATH_BACKUP
	if [ $FLAG = "y" ]; then
		echo -e "   All files will be transferred to the archive.\n"
		echo -e " *************\n | Progress: |\n *************\n"
		tar -zcvf "$(date '+%Y-%m-%d_%H-%M-%S').tar.gz" -C $PATH_LOG .
		rm -r $PATH_LOG*
	else
		read -p "   Set the number of files: " NUM_FILES_PARAM
		echo -e "   The first $NUM_FILES_PARAM previously created files will be transferred to the archive.\n"
		echo -e " *************\n | Progress: |\n *************\n"
		
		find $PATH_LOG -type f -printf '%C@\t%p\0' |
		sort -z -k1,1 -n |
		cut -z -f2 |
		head -z -n $NUM_FILES_PARAM | 
		xargs -0r tar -zcvf "$(date '+%Y-%m-%d_%H-%M-%S').tar.gz" --absolute-names --remove-files 
	fi
	echo -e "\n - Successfully!\n"
	
elif [ !"$(ls -A $PATH_LOG)" ]; then
	echo -e " - Your directory at the following adress (\"$PATH_LOG\") is empty!\n"
else
	echo -e " - You have enough space: $FREE_SPACE_LOG% free storage.\n"
fi 
