# Notes on simulation

## Install and run GEMC

1. Download the `clas12Tags` repository. Example:

    ```shell
    git clone https://github.com/ftouchte/clas12Tags
    cd clas12Tags
    # (optional) Go to the relevant branch
    git checkout fix/ahdc-geometry
    ```

1. (Optional) If the repository `coatjava` does not exist in `geometry_source/ `, the script of the next point will download the last release of the official `coatjava` repository. You can use your own version of `coatjava`. These command are used in `geometry_source/install_coatjava.sh`
    ```shell
    # Assuming you are in clas12Tags directory
    cd geometry_soruce
    git clone git@github.com:ftouchte/coatjava.git coatjava_src
    cd coatjava 
    # (optional) Go to the relevant branch
    git checkout tmp/ahdc-geom
    # Build 
    ./build-coatjava.sh --lfs --no-progress --nomaps
    # Create a install coatjava dir
    cp -r coatjava/ ../coatjava
    cp coatjava/lib/clas/* ..
    # Go back in clas12Tags
    cd ../..
    ```


1. Create geometry

    ```shell
    # set environment variable
    setenv GEMC_DATA_DIR $PWD
    # create the geometry
    create_geometry.sh
    ```

    `create_geometry.sh` will create the geometry for all detectors. Can be done once. If you need to modify the ALERT detector for example, you can take into account the modifications by doing: `create_geometry.sh alert`


1. Build `GEMC`

    ```shell
    cd source
    scons -j40 
    ```
    `scons -j40` is good on the ifarm. On your local machine, you can do `scons -j4`


1. Usage

    ```shell
    setenv GEMC_DATA_DIR /w/hallb-scshelf2102/clas12/users/touchte/clas12Tags

    $GEMC_DATA_DIR/source/gemc /scigroup/cvmfs/hallb/clas12/sw/noarch/clas12-config/dev/gemc/dev/rgl_spring2025_D2.gcard -USE_GUI=0 -BEAM_P="proton,200*MeV,90*deg,0*deg" -SPREAD_P="90*MeV, 30.0*deg, 180*deg" -N=10000 -OUTPUT='hipo, new_simu.hipo'
    ```

## Understand the geometry in GEMC. Case of AHDC

1. The geometry is defined in `coatjava`. Here: 

1. `GEMC` uses `geometry_source/alert/ahdc_factory.groovy` to generate `TEXT` file containing the information about the geometry of the AHDC in a given format. For the AHDC cell, we only need the (x,y) coordinates of the 12 vertices of the combined trapezoids and the half length in z. Example: this is the first three lines of the file `alert__volumes_defaults.txt`

    ```txt
    superlayer1_layer1_ahdccell1_subcell1 | root|   0.0000*mm   0.0000*mm 127.7000*mm |    0.0000*deg    0.0000*deg    0.0000*deg | G4GenericTrap | 175.2500*mm      33.924074*mm       2.270950*mm      34.000000*mm       0.000000*mm      30.000000*mm       0.000000*mm      29.933006*mm       2.003779*mm      32.791958*mm      -8.982623*mm      32.118756*mm     -11.152825*mm      28.340079*mm      -9.840728*mm      28.934080*mm      -7.925844*mm  |  1 1 1
    superlayer1_layer1_ahdccell1_subcell2 | root|   0.0000*mm   0.0000*mm 127.7000*mm |    0.0000*deg    0.0000*deg    0.0000*deg | G4GenericTrap | 175.2500*mm      29.933006*mm       2.003779*mm      29.732325*mm       3.998609*mm      33.696635*mm       4.531756*mm      33.924074*mm       2.270950*mm      28.934080*mm      -7.925844*mm      29.398855*mm      -5.975561*mm      33.318702*mm      -6.772302*mm      32.791958*mm      -8.982623*mm  |  1 1 1
    superlayer1_layer1_ahdccell2_subcell1 | root|   0.0000*mm   0.0000*mm 127.7000*mm |    0.0000*deg    0.0000*deg    0.0000*deg | G4GenericTrap | 175.2500*mm      33.318698*mm       6.772323*mm      33.696635*mm       4.531756*mm      29.732325*mm       3.998609*mm      29.398851*mm       5.975580*mm      33.696637*mm      -4.531735*mm      33.318702*mm      -6.772302*mm      29.398855*mm      -5.975561*mm      29.732327*mm      -3.998590*mm  |  1 1 2
    ```
    That's the purpose of the `create_geometry.sh`. This script uses `geometry_source/alert/ahdc_factory.groovy` and another one, `geometry_source/alert/ahdc_geometry_java.pl`. The last script read the TEXT file generated before to create the file `alert__geometry_default.txt` and update `clas12.sqlite` database.

1. In `GEMC/source` will use `source/detector/sqlite_det_factory.cc` (or `source/detector/text_det_factory.cc`) and `source/detector/detector_factory.cc` to read the `TXT` files or the `SQlite` db generated before to create a map of `detector` objects. 

1. This comment is available in `clas12Tags/source/hitprocess/clas12/alert/ahdc_hitprocess.cc`, in the method `ahdcSignal::ComputeDocaAndTime(MHit * aHit)`

    ```shell
    // The AHDC cell is the combination of 2 G4GenericTrap(ezoids) (subcell 1 and subcell2)
    // The numbering notation matches the one used in
    //     - clas12Tags --> geometry_source/alert/ahdc_factory.groovy
    //     - coatjava   --> common-tools/clas-geometry/src/main/java/org/jlab/geom/detector/alert/AHDC/AlertDCFactory.java
    // e.g
	//     - 01236789 and 34509(10)(11)6 are the two Trapezoids
	//     - 0 is on Rlayer+2 and 3 is on Rlayer-2
    //
	//                  0
	//  1                               5
	//             1st face on -z/2
    //          
	//                  3           
	//  2                               4
	//
    // - - - - - - - - -- - - -- - -- - - --  -
    //
	//                  6
	//  7                               11
	//             2nd face on +z/2
	//
	//                  9           
	//  8                               10
    //
    // Looking at aHit->GetDetectors()
	// 		- if the particle pass through only one subcell, the vector will have 1 components
	//		- if the particle pass through the two subcells, the vector will have 2 components
	// aHit->GetDetector() "without the s" return the first component aHit->GetDetectors() : it can be subcell 1 or 2
	// In aHit->GetDetector().dimensions, we will find the x,y coordinates of the 
    // 4 edges of the first face + the 4 edges of the second face of a given subcell numeroted as follow
    // Considering the number in parenthesis e.g (n), we have:
    //    - dimensions[2*n+1] contains the x coordinate of the point n
    //    - dimensions[2*n+2] contains the y coordinate of the point n
    // The numbers that are not in parenthesis match the one of the 2 faces of the AHDC cell represented above
    //
    //      subcell 1                |               subcell 2
    //                               |                       
	// 				    0(0)         |          0(3)
	//  1(1)                         |                          5(2)
	//        1st face               |                1st face           
	//	   			    3(3)         |          3(0)
	//  2(2)                         |                          4(1)
    //                               |                       
    //                               |                       
    //                               |      
	// 				    6(4)         |          6(7)
	//  7(5)                         |                          11(6)
	//        2nd face               |                 2nd face         
	//				    9(7)         |          9(4)
	//  8(6)			             |                          10(5)
    //                               |
	// In aHit->GetDetector().pos, we have x, y, z coordinates of the center of AHDC whith respect to the mother volume

	// In the last modification (February 2, 2026):
	// 		- we have extended the length of the AHDC wire (-150 and 150 became -188 and 162.mm) to match the true geometry
	// 		- but with these new values, we have some collisions with the end plates of the detector
	// 		- to prevent this, we reduce the sensitive volume of the wire doing a G4IntersectionSolid
	// We think the code will be must robust if if retrieve the x,y,z coordinates of the edges of the wire using the Geant4 classes
    ```



## Appendix

1. Use a local SQLite file as CCDB source. You can download a snapshot of the CCDB here: https://clasweb.jlab.org/clas12offline/sqlite/ccdb/ (Find more information in the CLAS12 software wiki).

    ```shell
    setenv CCDB_CONNECTION sqlite:////w/hallb-scshelf2102/clas12/users/touchte/data/simu/ccdb_2026-01-18.sqlite
    ```

1. Decoding (Use the PulseExtractorEngine --> ModeAHDC) This will create the AHDC::adc bank from AHDC::wf bank. `$COATAVA_DIR` is your path to coatjava

    ```shell
    $COATAVA_DIR/coatjava/bin/recon-util -i new_simu.hipo -o output_name.hipo org.jlab.clas.service.PulseExtractorEngine
    ```
