#!/bin/bash

# this folder contains lund files
folder=$1
ncpu=$2
nevents=$3
runno=$4
outdir=$5

gemc_dir="/w/hallb-scshelf2102/clas12/users/touchte/clas12Tags/source"
gcard_file="../alert-lund.gcard"

if [ ! -d "$folder" ]; then
	echo "> This folder does not exists: $folder"
	exit 1
fi

if [[ ! "$ncpu" =~ ^[0-9]+$ ]]; then
	echo "> $ncpu is not a number, it should correspond to the number of cpu"
	exit 1
fi

if [[ ! "$nevents" =~ ^[0-9]+$ ]]; then
	echo "> $nevents is not a number, it should correspond to the number of events"
	exit 1
fi

if [[ ! "$runno" =~ ^[0-9]+$ ]]; then
	echo "> $runno is not a number, it should correspond to the run number"
	exit 1
fi

if [ ! -d "./$outdir" ]; then
	echo "> This folder does not exists: $folder"
    mkdir $outdir
    echo "New folder created: $outdir"
fi
outdir=$(realpath $outdir)


#if [[ $ncpu -ge 32 ]]; then
#	echo "You attend to use more than 32 cpus: ncpu --> $ncpu"
#	echo "If you want to continue, you have to comment that verification in the script"
#	exit 1
#fi

#----------------------
# Start job
#----------------------
cd $folder
if [ ! -f "./$gcard_file" ]; then
	echo "> $gcard_file : file does not exist in this repository, it should be the gcard file"
	exit 1
fi
#parallel --dry-run --progress -j "$ncpu" "$gemc_dir/gemc $gcard_file -USE_GUI=0 -RUNNO=$runno -N=$nevents -INPUT_GEN_FILE='LUND, {/}' -OUTPUT='hipo, simu-{/.}.hipo' > {/.}.log 2>&1" ::: lund_file_*.dat 
parallel --progress -j "$ncpu" "$gemc_dir/gemc $gcard_file -USE_GUI=0 -RUNNO=$runno -N=$nevents -INPUT_GEN_FILE='LUND, {/}' -OUTPUT='hipo, $outdir/simu-{/.}.hipo' > $outdir/{/.}.log 2>&1" ::: lund_file_*.dat

