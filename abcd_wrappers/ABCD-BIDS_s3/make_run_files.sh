 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp/HCP-D" # where to output data
data_bucket="s3://HCP-Dv2_BIDS" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder=`pwd`

abcd_hcp_pipeline_folder="${run_folder}/run_files.abcd-hcp-pipeline_full"
abcd_hcp_pipeline_template="template.abcd-hcp-pipeline_full_run"

email=`echo $USER@umn.edu`
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

for i in `s3cmd ls ${data_bucket}`; do
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [[ "sub" == "${sub_text}" ]]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		sed -e "s|SUBJECTID|${subj_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${abcd_hcp_pipeline_template} > ${abcd_hcp_pipeline_folder}/run${k}
		k=$((k+1))
	fi
done

chmod +x -R ${abcd_hcp_pipeline_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_abcd-hcp-pipeline_full_run.sh 

