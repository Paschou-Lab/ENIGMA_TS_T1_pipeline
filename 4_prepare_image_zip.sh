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

###############
# Setup directory where volumes are
enigmadir=${1}
zipname=${2}

if [ -z ${enigmadir} ] || [ $# -gt 2 ] ; then

	echo "One directory must be specified"
	echo "Usage is: ./4_prepare_image_zip.sh <parent directory of project> <zip file name>"
	exit
fi

if [ ! -e ${enigmadir} ]; then
	echo "Input directory does not exist"
	exit
fi

#####################
# Prepare zip file
#####################

zipfile=${enigmadir}"/outputs/"$(basename ${zipname} | sed 's/\.zip//')".zip"

cd ${enigmadir}/outputs
echo ${PWD}

echo "Saving images and stats to zip file "${zipfile}

zip -r ${zipfile} . -i \*brainmask.mgz

# Remove images if Freesurfer did not complete
for subj_id in `ls -d sub* | grep -v "^subcortical$"`
do 
	if [ ! -s "${subj_id}/stats/aseg.stats" ] || [ ! -s "${subj_id}/stats/lh.aparc.stats" ] || [ ! -s "${subj_id}/stats/rh.aparc.stats" ]; then
		echo "WARNING: There were stats files missing for ${subj_id}, removing their images from the zip file."
		zip -d ${zipfile} ${subj_id}/mri/brainmask.mgz
	else
		zip -u -r ${zipfile} ${subj_id}/stats
	fi
done

exit 0
