# Simulation

## Run simulation with GEMC

1. Download the clas12Tags repository. Example:

    ```
    git clone https://github.com/ftouchte/clas12Tags
    ```

1. Create geometry

    ```
    cd clas12Tags

    setenv GEMC_DATA_DIR $PWD

    create_geometry.sh
    ```

1. Build gemc

    ```
    cd source

    scons -j40
    ```

1. Usage

    ```
    $GEMC_DATA_DIR/source/gemc /scigroup/cvmfs/hallb/clas12/sw/noarch/clas12-config/dev/gemc/dev/rgl_spring2025_D2.gcard -USE_GUI=0 -BEAM_P="proton,200*MeV,90*deg,0*deg" -SPREAD_P="90*MeV, 30.0*deg, 180*deg" -N=10000 -OUTPUT='hipo, new_simu.hipo'
    ```

1. Decoding (Use the PulseExtractorEngine --> ModeAHDC) This will create the AHDC::adc bank from AHDC::wf bank. `$COATAVA_DIR` is your path to coatjava

    ```
    $COATAVA_DIR/coatjava/bin/recon-util -i new_simu.hipo -o output_name.hipo org.jlab.clas.service.PulseExtractorEngine
    ```
