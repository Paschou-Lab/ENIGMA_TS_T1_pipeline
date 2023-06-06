#!/bin/bash

#####
# 2023-04-27
# Wrapper script to run the ENIGMA-TS T1 Freesurfer pipeline on a single subject in docker
#
#	
# Script assumes the following structure
#			Project_parent_directory/
#						-> inputs/
#							-> fs_license.txt (Freesurfer license file)
#							-> sub-001/sub-001.nii(.gz)
#							-> sub-002/sub-002.nii(.gz)
#							...
#						-> outputs/
#							-> sub-001 (freesurfer outputs)
#							-> sub-002
#							...
#
######

# docker image will be pulled from docker hub
docker_image="kollerj/enigma_ts:1.0.0"

# get ENIGMA-TS subject and basedir from command line
subject=${1}
enigmadir=${2}

# check input args
if [ -z ${subject} ]; then
	echo "Subject number must be specified"
	echo "Usage is: ./enigma_ts_t1_docker.sh <subject number> <parent directory of project>"
	exit
fi

if [ -z ${enigmadir} ]; then
	echo "Parent directory of 'inputs' folder must be specified"
	echo "Usage is: ./enigma_ts_t1_docker.sh <subject number> <parent directory of project>"
	exit
fi

if [ $# -gt 2 ] ; then
	echo "Too many arguments specified"
	echo "Usage is: ./enigma_ts_t1_docker.sh <subject number> <parent directory of project>"
	exit
fi

if [ ! -e ${enigmadir} ] || [ ! -e ${enigmadir}/inputs/${subject}/${subject}.nii.gz ]; then
	echo "Input directory or subject does not exist! Please check"
	exit
fi

# full paths to ENIGMA-TS inputs and outputs directories
inputs_local_path=${enigmadir}/inputs
outputs_local_path=${enigmadir}/outputs

# check for Freesurfer license file
if [ ! -e ${enigmadir}/inputs/fs_license.txt ]; then
	echo "ERROR: Freesurfer license file not found in ${enigmadir}/inputs/"
	exit
fi

# get user id and group id number for docker
userid_num=`id -u`
groupid_num=`id -g`

# ENIGMA-TS script command and inputs
enigma_fs_run_one_cmd="/ENIGMA-TS/ENIGMA_TS_T1_pipeline/1_enigma_runfreesurfer.sh"
enigma_base_dir="/ENIGMA-TS"
enigma_subjid=${subject}

# docker run command
docker run -it --rm \
    --env FS_LICENSE=/ENIGMA-TS/inputs/fs_license.txt \
    --volume ${inputs_local_path}:/ENIGMA-TS/inputs \
    --volume ${outputs_local_path}:/ENIGMA-TS/outputs \
    --user ${userid_num}:${groupid_num} \
    ${docker_image} \
    ${enigma_fs_run_one_cmd} ${enigma_subjid} ${enigma_base_dir}

