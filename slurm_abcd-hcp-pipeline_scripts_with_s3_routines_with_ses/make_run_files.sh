 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
RANDOM_HASH=`tr -dc A-Za-z0-9 </dev/urandom | head -c 10 ; echo ''`
data_dir="/tmp/${RANDOM_HASH}" # where to output data
data_bucket="s3://ABCD_missing_SST" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder=`pwd`

abcd_hcp_pipeline_folder="${run_folder}/run_files.abcd-hcp-pipeline_full"
abcd_hcp_pipeline_template="template.abcd-hcp-pipeline_full_run"

group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${abcd_hcp_pipeline_folder}" ]; then
	rm -rf "${abcd_hcp_pipeline_folder}"
	mkdir -p "${abcd_hcp_pipeline_folder}/logs"
else
	mkdir -p "${abcd_hcp_pipeline_folder}/logs"
fi

# counter to create run numbers
k=0

for i in `s3cmd ls ${data_bucket}/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket}/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'` # CHANGE THIS?
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # CHANGE THIS?
				# I think this sed statement needs to be changed
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${abcd_hcp_pipeline_template} > ${abcd_hcp_pipeline_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${abcd_hcp_pipeline_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_abcd-hcp-pipeline_full_run.sh 

