#!/bin/bash

set +x 

# Initialize variables with default values
s3_bids_path="s3://BUCKET_NAME/" # BIDS directory on S3 bucket where BIDS data will be pulled from (include "s3://")
output_dir="ENTER/OUTPUT/PATH/" # where to save the data
run_folder=`pwd`

email=`echo $lmoore@umn.edu`
group=`groups|cut -d" " -f1`

# Define usage function
#function usage {
#  echo "Usage: $0 --s3-bids-path S3_URL --output_dir OUTPUT_DIRECTORY --wb_command-dir WB_COMMAND"
#}

# Parse command line arguments
#while [[ $# -gt 0 ]]; do
#  key="$1"
#  case $key in
#    --s3-bids-path)
#      s3_bids_path="$2"
#      shift
#      shift
#      ;;
#    --output_dir)
#      s3_upload_path="$2"
#      shift
#      shift
#      ;;
#    --wb_command-dir)
#      wb_command_path="$2"
#      shift
#      shift
#      ;;
#    *)
#      usage
#      exit 1
#      ;;
#  esac
#done

# Check that required arguments are provided
#if [[ -z "$s3_bids_path || -z "$output_dir || -z "$wb_command_path" || -z "$repetition_time" ]]; then
#  usage
#  exit 1
#fi

run_files_folder="${run_folder}/run_files.syncTM"
TM_template="template.s3sync_then_TM_run"
infomap_jsons_folder="${run_folder}/infomap_jsons"


# if processing run folders exist delete them and recreate
if [ -d "${run_files_folder}" ]; then
	rm -rf "${run_files_folder}"
	mkdir -p "${run_files_folder}/logs"
else
	mkdir -p "${run_files_folder}/logs"
fi

#copy infomap jsons required to be located in run directory
cp "$infomap_jsons_folder"/* "$run_files_folder"

# counter to create run numbers
k=0
echo $s3_bids_path

for i in `s3cmd ls "${s3_bids_path}"/ | awk '{print $2}'`; do
	# does said folder include subject folder?
echo $i
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls "${s3_bids_path}"/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` 
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|S3BIDSPATH|${s3_bids_path}|g" -e "s|WB_COMMAND|${wb_command_path}|g" -e "s|FD_THRESHOLD|${fd_threshold}|g" -e "s|REPETITION_TIME|${repetition_time}|g" -e "s|MINUTES_LIMIT|${minutes_limit}|g" -e "s|OUTPUT_DIR|${output_dir}|g"  ${run_folder}/${TM_template} > ${run_files_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${run_files_folder}


sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_TM_run.sh 

