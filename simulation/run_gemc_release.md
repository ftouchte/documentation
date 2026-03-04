## Simulation

```shell
# downloag the git repo
git clone https://github.com/gemc/clas12Tags.git
cd clas12Tags

# look at a specific release
git fetch --tags
git tag
git checkout 5.13

# set environment variable
setenv GEMC_DATA_DIR $PWD
# create the geometry
create_geometry.sh

# build source
cd source
scons -j40

# (This is not related to the error you have)
# In this table, I have updated the AHDC t0 and raw_hit_cuts table for the run 11 to match the ones of the run 22712
setenv CCDB_CONNECTION sqlite:////w/hallb-scshelf2102/clas12/users/touchte/data/simu/ccdb_2026-02-01.sqlite
    # just to check check
    ccdb vers /calibration/alert/ahdc/raw_hit_cuts
    ccdb vers /calibration/alert/ahdc/time_offsets

# An example of gcard is locate here
/w/hallb-scshelf2102/clas12/users/touchte/data/simu/alert-D2-only.gcard

# Example of use
$GEMC_DATA_DIR/source/gemc alert-D2-only.gcard -USE_GUI=0 -RUNNO=11 -N=10000 -OUTPUT='hipo, new_simu.hipo'
```

## Reconstruction

```shell
# Example of yaml file
/w/hallb-scshelf2102/clas12/users/touchte/data/simu/simu_alert_clas12_config.yaml

# Run reconstruction
# $COATJAVA is the path to coatjava, e.g (/w/hallb-scshelf2102/clas12/users/touchte/coatjava/coatjava)
$COATJAVA/bin/recon-util -y simu_alert_clas12_config.yaml -i new_simu.hipo -o rec_new_simu.hipo
```