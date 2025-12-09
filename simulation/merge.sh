#!/bin/bash

dossier=$1
version=$2



if [ ! -d "./$dossier" ]; then
	echo "> This folder does not exist: $dossier"
	exit 1
fi

if [[ ! "$version" =~ ^[0-9]+$ ]]; then
        echo "> $version is not a number, it should correspond to the version number"
        exit 1
fi
#----------------------
# Start job
#----------------------

cd $dossier

hipo-utils -merge -o "rec-simu-deuteron-v$version.hipo" rec-file*


echo ">> Path of the new file:"
ls $PWD/rec-simu*
