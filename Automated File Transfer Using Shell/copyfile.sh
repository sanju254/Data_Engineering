#!/bin/bash

#This script is to copy files on a daily schedule
cmd_args=$#
echo "num of args: $cmd_args"
if [ $cmd_args -eq 0 ]
then
	daily=$(date +"%Y%m%d")
	filename="Antwak$daily.csv"
	sourcepath="/home/shameerphy/source/$filename"
	destinationpath="/home/shameerphy/destination"
	if [ -f $sourcepath ]
	then
		mv $sourcepath $destinationpath
		echo "********************************"
		echo "File copied Successfully"
		echo "********************************"
	else
		mail -s "File is not found" shameerkhan.dev@gmail.com
	fi
elif [ $cmd_args -eq 1 ]
then
	daily=$1
	filename="Antwak$daily.csv"
	sourcepath="/home/shameerphy/source/$filename"
	destinationpath="/home/shameerphy/source/$filename"
	if [ -f $sourcepath ]
	then
		mv $sourcepath $destinationpath
		echo "*******************************"
		echo "File copied Successfully"
		echo "*******************************"
	else 
		mail -s "File is not found" shameerkhan.dev@gmail.com
	fi
else
	echo "**************************************************"
	echo "Please check the number of arguments passed"
	echo "**************************************************"
fi
