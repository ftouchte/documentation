#!/bin/bash

filename=$1
nevents=$2
dossier=$3
#ncpu=$3

#hipo-utils -info $filename | awk '/number of  events/ {print $NF}'

#set -e


if [ ! -f "./$filename" ]; then
	echo "> $filename does not exist in this repository"
	exit 1
fi

if [[ ! "$nevents" =~ ^[0-9]+$ ]]; then
	echo "> $nevents is not a number"
	exit 1
fi

if [ -d "./$dossier" ]; then
	echo "> This folder already exists: $dossier"
	exit 1
fi

#----------------------
# Start job
#----------------------

echo "> Processing $filename..."
echo "> Run: hipo-utils -split -n $nevents $filename"
	hipo-utils -split -n $nevents $filename
echo "> Folder created: $dossier"
	num="0";
	files=(${filename}_*)
	mkdir $dossier
	cd $dossier
	#ls ${filename}_*
	for file in "${files[@]}"; do
		((num++))
		if [ -e "../$file" ]; then
			mv "../$file" "file_$num.hipo"
			#echo "> new file file_$num.hipo"
		fi
	done
	echo "Source file: ../$filename" > readme.txt
	echo "N° portions: $num" >> readme.txt
echo "> All files moved in: $dossier"
