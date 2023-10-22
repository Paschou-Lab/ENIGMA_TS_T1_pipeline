#!/bin/bash
#####
# Wrapper written by Jon Koller (kollerj@wustl.edu)
#
#	
# Script assumes the following structure
#			Project_parent_directory/
#						-> inputs/ (nii files 1_enigma_runfreesurfer.sh script,
#													not used here)
#						-> outputs/
#							-> subj01(freesurfer outputs)
#							-> subj02
#							...
#						-> enigma_wrapscripts/ (copied from elsewhere)
#
######

# Parse inputs
enigmadir=${1}
zipname=${2}

if [ -z ${enigmadir} ] || [ $# -gt 2 ] ; then

	echo "One directory must be specified"
	echo "Usage is: ./5_prepare_QA_upload.sh <parent directory of project> <zip file name>"
	exit 1
fi

if [ ! -e ${enigmadir} ]; then
	echo "Input directory does not exist"
	exit 1
fi

#####################
# Prepare zip file
#####################

zipfile=${enigmadir}"/outputs/"$(basename ${zipname} | sed 's/\.zip//')".zip"

cd ${enigmadir}/outputs
echo ${PWD}

if [ ! -e "subcortical/LandRvolumes.csv" ]; then
	echo "${enigmadir}/outputs/subcortical/LandRvolumes.csv does not exist, please run the 2_ and 3_ scripts first"
	exit 1
fi

# Initialize subject/session/series list
sublist_csv=$(echo ${zipfile} | sed 's/\.zip/\.csv/')
if [ -e "${sublist_csv}" ]; then
    /bin/rm ${sublist_csv}
fi
echo "subjid,BIDS subject,BIDS session,SeriesNumber" > ${sublist_csv}

echo "Looping over subcortical/LandRvolumes.csv, creating record of subjects/sessions/series"
{
	read
	while IFS=, read -r subjid LLatVent RLatVent ThirdVentricle FourthVentricle Lthal Rthal Lcaud Rcaud Lput Rput Lpal Rpal Lhippo Rhippo Lamyg Ramyg Laccumb Raccumb BrainStem ICV
	do
        BIDS_subject=""
        BIDS_session=""
        series_number=""

		# Get SeriesNumber from BIDS json if it exists
        BIDS_json=${enigmadir}/inputs/${subjid}/${subjid}.json
		if [ -e "${BIDS_json}" ]; then
            series_number=$(grep SeriesNumber ${BIDS_json} | head -1 | cut -d":" -f2 | cut -d"," -f1 | awk '{print $1}')
        fi

        # Get BIDS subject and session if ${subjid} is BIDS-like
        if [[ "${subjid}" =~ ^sub-.*[0-9a-z]_ses-.*[0-9a-z]_?.*$ ]]; then
            BIDS_subject=$(echo ${subjid} | cut -d"_" -f1 | sed 's/sub-//')
            BIDS_session=$(echo ${subjid} | cut -d"_" -f2 | sed 's/ses-//')
        fi

        echo "${subjid},${BIDS_subject},${BIDS_session},${series_number}" >> ${sublist_csv}
    done
} < subcortical/LandRvolumes.csv

sublist_csv_basename=$(basename ${sublist_csv})

echo "Saving QA data to zip file "${zipfile}

zip -r ${zipfile} cortical subcortical ${sublist_csv_basename}

exit 0
