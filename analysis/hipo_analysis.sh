#!/bin/bash

# This script generate a routine to read HIPO file
# @date January 5, 2026
# @author Felix Touchte Codjo

DATE=$(LC_TIME=en_US.UTF-8 date +"%B %d, %Y")
AUTHOR="Felix Touchte Codjo"
DESCRIPTION=""
OUTPUT=$1

if [ -z "$OUTPUT" ]; then
    OUTPUT="out.cpp"
fi

cat <<EOF >> "$OUTPUT"
/***********************************************
 * $DESCRIPTION
 *
 * @author $AUTHOR
 * @date $DATE
 * ********************************************/
EOF
echo '' >> $OUTPUT
echo '#include <cstdlib>' >> $OUTPUT
echo '#include <cstdio>' >> $OUTPUT
echo '#include <cmath>' >> $OUTPUT
echo '' >> $OUTPUT
echo '#include <vector>' >> $OUTPUT
echo '#include <string>' >> $OUTPUT
echo '#include <chrono>' >> $OUTPUT
echo '' >> $OUTPUT
echo '#include "reader.h"' >> $OUTPUT
echo '' >> $OUTPUT
echo '#include "TH1.h"' >> $OUTPUT
echo '#include "TH2.h"' >> $OUTPUT
echo '#include "TCanvas.h"' >> $OUTPUT
echo '#include "TFile.h"' >> $OUTPUT
echo '#include "TDirectory.h"' >> $OUTPUT
echo '#include "TGraph.h"' >> $OUTPUT
echo '#include "TGraphErrors.h"' >> $OUTPUT
echo '#include "TStyle.h"' >> $OUTPUT
echo '#include "TString.h"' >> $OUTPUT
echo '#include "TLegend.h"' >> $OUTPUT
echo '#include "TF1.h"' >> $OUTPUT
echo '#include "Math/PdfFuncMathCore.h"' >> $OUTPUT
echo '#include "TText.h"' >> $OUTPUT
echo '#include "THStack.h"' >> $OUTPUT
echo '' >> $OUTPUT
echo '// utilities' >> $OUTPUT
echo 'void progressBar(int state, int bar_length = 100);' >> $OUTPUT
echo '' >> $OUTPUT
echo 'int main(int argc, char const *argv[]) {' >> $OUTPUT
echo '    auto start = std::chrono::high_resolution_clock::now();' >> $OUTPUT
echo '    ' >> $OUTPUT
echo '    // set filename and initialise reader' >> $OUTPUT
echo '    const char* filename = "filename.hipo";' >> $OUTPUT
echo '    const char * output = "output_name.root";' >> $OUTPUT
echo '    printf("> filename : %s\n", filename);' >> $OUTPUT
echo '    hipo::reader  reader(filename);' >> $OUTPUT
echo '    hipo::dictionary factory;' >> $OUTPUT
echo '    reader.readDictionary(factory);' >> $OUTPUT
echo '    // bank definition' >> $OUTPUT
echo '    hipo::bank  adcBank(factory.getSchema("AHDC::adc"));' >> $OUTPUT
echo '    hipo::bank  wfBank(factory.getSchema("AHDC::wf"));' >> $OUTPUT
echo '    hipo::bank  trackBank(factory.getSchema("AHDC::kftrack"));' >> $OUTPUT
echo '    hipo::bank  hitBank(factory.getSchema("AHDC::hits"));' >> $OUTPUT
echo '    hipo::bank  mcBank(factory.getSchema("MC::Particle"));' >> $OUTPUT
echo '    hipo::event event;' >> $OUTPUT
echo '    long unsigned int nevents =0;' >> $OUTPUT
echo '' >> $OUTPUT
echo '    // example of 1D histograms' >> $OUTPUT
echo '    TH1D* H1_mctime = new TH1D("mctime", "mctime; mctime (ns); count", 100, 0, 250); ' >> $OUTPUT
echo '    // example of 2D histograms' >> $OUTPUT
echo '    TH2D* H2_corr_time = new TH2D("corr_time", "time vs mctime; mctime (mm); time (mm)", 100, 0, 250, 100, 0, 250);' >> $OUTPUT
echo '' >> $OUTPUT
echo '    // Loop over events' >> $OUTPUT
echo '    while( reader.next()){' >> $OUTPUT
echo '        nevents++;' >> $OUTPUT
echo '        // display progress Bar' >> $OUTPUT
echo '        if ((nevents % 1000 == 0) || ((int) nevents == reader.getEntries())) {' >> $OUTPUT
echo '            progressBar(100.0*nevents/reader.getEntries());' >> $OUTPUT
echo '        }' >> $OUTPUT
echo '        // load bank content for this event' >> $OUTPUT
echo '        reader.read(event);' >> $OUTPUT
echo '        event.getStructure(adcBank);' >> $OUTPUT
echo '        event.getStructure(wfBank);' >> $OUTPUT
echo '        event.getStructure(trackBank);' >> $OUTPUT
echo '        event.getStructure(hitBank);' >> $OUTPUT
echo '        event.getStructure(mcBank);' >> $OUTPUT
echo '' >> $OUTPUT
echo '        //////////////////////////////////' >> $OUTPUT
echo '        // ' >> $OUTPUT
echo '        // The analysis can be done here.' >> $OUTPUT
echo '        //' >> $OUTPUT
echo '        //////////////////////////////////' >> $OUTPUT
echo '' >> $OUTPUT
echo '' >> $OUTPUT
echo '    }' >> $OUTPUT
echo '' >> $OUTPUT
echo '    // save the output in a ROOT file' >> $OUTPUT
echo '    TFile *f = new TFile(output, "RECREATE");' >> $OUTPUT
echo '        // routine to create a directory in a TFile' >> $OUTPUT
echo '        // TDirectory *adc_dir = f->mkdir("adc");' >> $OUTPUT
echo '        // adc_dir->cd();' >> $OUTPUT
echo '    // save a histogram' >> $OUTPUT
echo '    H1_time->Write("time");' >> $OUTPUT
echo '        // ou H1_time->Write(H1_time->GetName());' >> $OUTPUT
echo '' >> $OUTPUT
echo '' >> $OUTPUT
echo '    f->Close();' >> $OUTPUT
echo '    printf("File created : %s\n", output);' >> $OUTPUT
echo '    ' >> $OUTPUT
echo '    // end of the program' >> $OUTPUT
echo '    auto end = std::chrono::high_resolution_clock::now();' >> $OUTPUT
echo '    auto elapsed = std::chrono::duration<double>(end - start);' >> $OUTPUT
echo '    printf("* time elapsed : %lf seconds\n", elapsed.count());' >> $OUTPUT
echo '    return 0;' >> $OUTPUT
echo '}' >> $OUTPUT
echo '' >> $OUTPUT
echo 'void progressBar(int state, int bar_length) { // state is a number between 0 and 100' >> $OUTPUT
echo '    // for the moment the bar length is not variable' >> $OUTPUT
echo '    if (state > bar_length) {return ;}' >> $OUTPUT
echo '    printf("\rProgress \033[32m\[");' >> $OUTPUT
echo '    for (int i = 0; i <= state; i++) {' >> $OUTPUT
echo '        printf("#");' >> $OUTPUT
echo '    }' >> $OUTPUT
echo '    printf("\033[0m");' >> $OUTPUT
echo '    for (int i = state+1; i < bar_length; i++) {' >> $OUTPUT
echo '        printf(".");' >> $OUTPUT
echo '    }' >> $OUTPUT
echo '    if (state == 100) {' >> $OUTPUT
echo '        printf("\033[32m] \033[1m %d %%\033[0m\n", state);' >> $OUTPUT
echo '    } else {' >> $OUTPUT
echo '        printf("] %d %%", state);' >> $OUTPUT
echo '    }' >> $OUTPUT
echo '    fflush(stdout);' >> $OUTPUT
echo '}' >> $OUTPUT
echo '' >> $OUTPUT
echo '' >> $OUTPUT
