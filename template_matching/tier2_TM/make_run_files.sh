#!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp" # where to output data during processing (typically /tmp/ or /scratch.global/ path)
template_id="ABCD"
mask="none"
data_bucket="s3://<xcpd_bucket>/xcpd" # bucket that input data will be pulled from 
output_bucket="s3://<template_matching_bucket>/output" # bucket where outputs will be pushed to
run_folder=`pwd`

TM_folder="${run_folder}/run_files.TM_full"
TM_template="template.TM_full_run"

# if processing run folders exist delete them and recreate
if [ -d "${TM_folder}" ]; then
	rm -rf "${TM_folder}"
	mkdir -p "${TM_folder}"
else
	mkdir -p "${TM_folder}"
fi

# Grab users email and main group to replace in resources file
email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`
sed -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_TM_full_run.sh 
sed -e "s|GROUP|${group}|g" -i ${run_folder}/resources_TM_full_run.sh 


# counter to create run numbers
k=0

# Loop through input bucket to grab all subject/session pairs
for i in `s3cmd ls ${data_bucket}/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	ses_text=`echo ${i} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $2}' | awk -F"_" '{print $2}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}' | awk -F"_" '{print $1}'`
		if [ "ses" = "${ses_text}" ]; then
			ses_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $3}'` # Grab session ID
			# Replace variables from template into run file
			sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESSIONID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|TEMPLATEID|${template_id}|g" -e "s|MASKFILE|${mask}|g" -e "s|INBUCKET|${data_bucket}|g" -e "s|OUTBUCKET|${output_bucket}|g" ${run_folder}/${TM_template} > ${TM_folder}/run${k}
			k=$((k+1))
		fi
	fi
done

chmod 775 -R ${TM_folder}

