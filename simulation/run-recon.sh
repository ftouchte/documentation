#!/bin/bash

folder=$1
ncpu=$2

coatjava_dir="/w/hallb-scshelf2102/clas12/users/touchte/coatjava/"
#coatjava_dir="/w/hallb-scshelf2102/clas12/users/touchte/coatjava-simu/"
#yaml_file="../ahdc_config.yaml"
yaml_file="../alert_clas12_config.yaml"

if [[ ! "$ncpu" =~ ^[0-9]+$ ]]; then
	echo "> $ncpu is not a number, it should correspond to the number of cpu"
	exit 1
fi

if [ ! -d "./$folder" ]; then
	echo "> This folder does not exists: $folder"
	exit 1
fi

#if [[ $ncpu -ge 32 ]]; then
#	echo "You attend to use more than 32 cpus: ncpu --> $ncpu"
#	echo "If you want to continue, you have to comment that verification in the script"
#	exit 1
#fi

#----------------------
# Start job
#----------------------
cd $folder
if [ ! -f "./$yaml_file" ]; then
	echo "> $yaml_file : file does not exist in this repository, it should be the yaml file"
	exit 1
fi
parallel --progress -j "$ncpu" "$coatjava_dir/coatjava/bin/recon-util -y $yaml_file -i {} -o rec-{/} > {/.}.log 2>&1" ::: file_*.hipo 

