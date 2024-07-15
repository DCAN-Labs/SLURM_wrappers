 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/scratch.global/lundq163/TM_work_CLM_test" # where to output data
template_id="ABCD"
mask="none"
data_bucket="s3://motormapping/fmriprep_xcpd_outputs/xcpd" # bucket that BIDS data will be pulled from 
output_bucket="s3://motormapping/template_matching_outputs"
run_folder="/home/aopitz/lundq163/motormapping_code/TM_wrapper"

TM_folder="${run_folder}/run_files.TM_full"
TM_template="template.TM_full_run"

# if processing run folders exist delete them and recreate
if [ -d "${TM_folder}" ]; then
	rm -rf "${TM_folder}"
	mkdir -p "${TM_folder}"
else
	mkdir -p "${TM_folder}"
fi

# counter to create run numbers
k=0

for i in `s3cmd ls ${data_bucket}/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	ses_text=`echo ${i} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $2}' | awk -F"_" '{print $2}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}' | awk -F"_" '{print $1}'`
		if [ "ses" = "${ses_text}" ]; then
			ses_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $3}'` # CHANGE THIS?
			# I think this sed statement needs to be changed
			sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESSIONID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|TEMPLATEID|${template_id}|g" -e "s|MASKFILE|${mask}|g" -e "s|INBUCKET|${data_bucket}|g" -e "s|OUTBUCKET|${output_bucket}|g" ${run_folder}/${TM_template} > ${TM_folder}/run${k}
			k=$((k+1))
		fi
	fi
done

chmod 775 -R ${TM_folder}

