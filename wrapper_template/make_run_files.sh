#!/bin/bash

set +x 
# Determine data directory, run folders, and run templates
# Don't include the trailing / on paths
data_dir="/tmp" # where to output data temporarily during the SLURM job
input_bucket="s3://" # bucket that input data will be pulled from, provide full path to where subject subfolders are located
output_path="" # tier1 or s3 path that processed outputs will be pushed to
working_folder=`pwd`
ses_id="" # optional: specify a specific session to use (without "ses-" prefix)
subject_list="" # optional: specifiy a list of subjects to run

process_folder="${run_folder}/run_files"
process_template="template"

# if processing run folders exist delete them and recreate
if [ -d "${process_folder}" ]; then
	rm -rf "${process_folder}"
	mkdir -p "${process_folder}/logs"
else
	mkdir -p "${process_folder}/logs"
fi

# counter to create run numbers
k=0

##################################################
### CHOOSE METHOD OF SUBJECT RUN FILE CREATION ###
##################################################

# Method 1: Loop through list of subjects to create run files, use specified ses_id; expecting file to be formatted "sub-SUBID" with each subject on new line
cat ${subject_list} | while read line; do
	sed -e "s|SUBJECTID|${line}|g" -e "s|SESID|ses-${ses_id}|g" -e "s|INPUT|${input_bucket}|g" -e "s|DATADIR|${data_dir}|g" -e "s|OUTPUT|${output_path}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${process_template} > ${process_folder}/run${k}

	k=$((k+1))
done

# Method 2: Loop through list of subject/session pairs to create run files; expecting file to be formatted "sub-SUBID,ses-SESID" with each pair on a new line
while IFS=',' read -r subid sesid rest_of_line; do
	sed -e "s|SUBJECTID|${subid}|g" -e "s|SESID|${sesid}|g" -e "s|INPUT|${input_bucket}|g" -e "s|DATADIR|${data_dir}|g" -e "s|OUTPUT|${output_path}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${process_template} > ${process_folder}/run${k}
	k=$((k+1))
done < "$subject_list"

# Method 3: Loop through s3 bucket and pull down every subject/session pair 
# Ensure that path to input data matches your bucket structure! 
for i in `s3cmd ls ${data_bucket}/BIDS/ | awk '{print $2}'`; do
	# Check if folder is subject folder
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket}/BIDS/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'` 
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # COMMENT THIS OUT IF USING SPECIFIED SESSION 
				sed -e "s|SUBJECTID|sub-${subj_id}|g" -e "s|SESID|ses-${ses_id}|g" -e "s|INPUT|${input_bucket}|g" -e "s|DATADIR|${data_dir}|g" -e "s|OUTPUT|${output_path}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${process_template} > ${process_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${process_folder}

# Grab user email and main group, replace in resource file 
email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`
sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources.sh 

