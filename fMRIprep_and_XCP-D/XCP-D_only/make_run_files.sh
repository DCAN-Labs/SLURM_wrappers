#!/bin/bash

set +x 

# Initialize variables with default values
# Do not include trailing / on paths
s3_preprocess_path="" # directory on S3 bucket where preprocessed data will be pulled from (include "s3://")
s3_upload_path="" # where to upload output to on S3
preprocess_dir="" # tmp parent directory to create for pulling down preprocessed derivatives
xcpd_dir="" # tmp parent directory to create for xcp_d derivatives and work
band_stop_min="" # sets xcp_d respiratory filter min/max freq; if one of min/max is specified then both must be specified
band_stop_max="" 
xcpd_clean_workdir=false # run xcp_d with --clean-workdir
low_resources=false # request reduced resources (default: 120c/960G/48:00:00; low: 24c/240G/48:00:00)
run_folder=`pwd`


# Check that --band-stop-min and --band-stop-max are provided together
if [[ ! -z "$band_stop_min" && -z "$band_stop_max" ]]; then
  exit 1
elif [[ -z "$band_stop_min" && ! -z "$band_stop_max" ]]; then
  exit 1
fi

xcpd_folder="${run_folder}/run_files.xcpd"
xcpd_template="template.xcpd_run"

# if processing run folders exist delete them and recreate
if [ -d "${xcpd_folder}" ]; then
	rm -rf "${xcpd_folder}"
	mkdir -p "${xcpd_folder}/logs"
else
	mkdir -p "${xcpd_folder}/logs"
fi

# counter to create run numbers
k=0
# Loop through s3 bucket to grab subject and session information
for i in `s3cmd ls "${s3_preprocess_path}"/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls "${s3_preprocess_path}"/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` 
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|PREPROCDIR|${preprocess_dir}|g" -e "s|XCPDDIR|${xcpd_dir}|g" -e "s|S3PREPROCPATH|${s3_preprocess_path}|g" -e "s|S3UPLOADPATH|${s3_upload_path}|g" -e "s|RUNDIR|${run_folder}|g" -e "s|BSMIN|${band_stop_min}|g" -e "s|BSMAX|${band_stop_max}|g" -e "s|XCPDCLEAN|${xcpd_clean_workdir}|g" ${run_folder}/${xcpd_template} > ${xcpd_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${xcpd_folder}

# Grab user email and main group, replace in resource file 
email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`
sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_xcpd.sh 

