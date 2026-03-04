## Update table a CCDB

Practice case: copy the tables for run 22712 into run 11 (useful for simulation)

1. Set `CCDB_CONENCTION` to the local table (snapshot can be found here : https://clasweb.jlab.org/clas12offline/sqlite/ccdb/)

    ```shell
    setenv CCDB_CONNECTION sqlite:////w/hallb-scshelf2102/clas12/users/touchte/data/simu/ccdb_2026-02-01.sqlite
    ```

1. Dump table for run 22712

    ```shell
    # t0 table
    ccdb -r 22712 dump /calibration/alert/ahdc/time_offsets
    ccdb -r 22712 dump /calibration/alert/ahdc/time_offsets > time_offsets.txt

    # raw_hit_cuts table
    ccdb -r 22712 dump /calibration/alert/ahdc/raw_hit_cuts
    ccdb -r 22712 dump /calibration/alert/ahdc/raw_hit_cuts > raw_hit_cuts.txt
    ```

1. Open `time_offsets.txt` et `raw_hit_cuts.txt`. Make sure all comments start with "#"

    Before

    ```shell
        Working run is 22712
        # Sector Layer Component t0 dt0 extra1 extra2 chi2ndf
        1            11           1            180.5523     10.9775      0.0          0.0          2.01
        1            11           2            182.5884     11.9540      0.0          0.0          2.79
        1            11           3            181.6729     12.9162      0.0          0.0          2.02
        1            11           4            178.9158     11.9008      0.0          0.0          1.88
    ```

    After

    ```shell
        #Working run is 22712
        # Sector Layer Component t0 dt0 extra1 extra2 chi2ndf
        1            11           1            180.5523     10.9775      0.0          0.0          2.01
        1            11           2            182.5884     11.9540      0.0          0.0          2.79
        1            11           3            181.6729     12.9162      0.0          0.0          2.02
        1            11           4            178.9158     11.9008      0.0          0.0          1.88
    ```

1. Update the CCDB tables for run 11

    ```shell
    ccdb add /calibration/alert/ahdc/time_offsets -r 11-11 time_offsets.txt
    ccdb add /calibration/alert/ahdc/raw_hit_cuts -r 11-11 raw_hit_cuts.txt
    ```

1. Verification

    ```shell
    ccdb vers /calibration/alert/ahdc/raw_hit_cuts
    ccdb vers /calibration/alert/ahdc/time_offsets

    ccdb -r 11 dump /calibration/alert/ahdc/time_offsets
    ccdb -r 11 dump /calibration/alert/ahdc/raw_hit_cuts
    ```

