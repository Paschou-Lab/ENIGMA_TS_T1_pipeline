### ENIGMA_TS structural imaging  pipeline 

ENIGMA-TS pipelines to analyze structural brain MRI data (cortical and subcortical segmentation and quality control using FreeSurfer versions 6 and 7). This wrapper script fixes tksurfer command error (removed from latest FreeSurfer versions) and was put together by Yin Jin, integrating scripts provided by Sophia Thomopoulos and existing [ENIGMA wrapper scripts](https://enigma.ini.usc.edu/protocols/imaging-protocols/) and [published ENIGMA pipelines](https://github.com/npnl/ENIGMA-Wrapper-Scripts). [Further documentation](https://github.com/Paschou-Lab/ENIGMA_TS_T1_pipeline/blob/main/README_basic.pdf) available here. For questions please contact Yin Jin (jin368@purdue.edu).


## update 2_extractsubcortical_volumes.sh on 05/22/2022
Because Freesurfer version 6 and 7 volume names are slightly different, we provide two transcripts (2_extractsubcortical_volumes_version6.sh and 2_extractsubcortical_volumes_version7.sh) to extract subcortical volumes. 

