 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_bucket="$1" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
data_dir="$2" # where to output for nibabies
xcpd_dir="$3" # where to output for xcp-d
run_folder=`pwd`

nibabies_folder="${run_folder}/run_files.nibabies_full"
nibabies_template="template.nibabies_full_run"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${nibabies_folder}" ]; then
	rm -rf "${nibabies_folder}"
	mkdir -p "${nibabies_folder}/logs"
else
	mkdir -p "${nibabies_folder}/logs"
fi

# counter to create run numbers
k=0

for i in `s3cmd ls ${data_bucket}/sorted/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket}/sorted/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'` # CHANGE THIS?
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # CHANGE THIS?
				# I think this sed statement needs to be changed
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|XCPDDIR|${xcpd_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${nibabies_template} > ${nibabies_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${nibabies_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_nibabies_full_run.sh 

