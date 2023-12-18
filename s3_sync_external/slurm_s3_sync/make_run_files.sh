 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp/ABIDE1" # where to output data
data_bucket_input="s3://ABIDE1" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
data_bucket_output="s3://fcp-indi/data/Projects/ABIDE/RawDataBIDS/sidecards/"
run_folder=`pwd`

sync_folder="${run_folder}/run_files.sync"
sync_template="template.sync"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${sync_folder}" ]; then
	rm -rf "${sync_folder}"
	mkdir -p "${sync_folder}/logs"
else
	mkdir -p "${sync_folder}/logs"
fi

# counter to create run numbers



k=0

for i in `s3cmd ls ${data_bucket_input}/sorted/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket_input}/sorted/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'` # CHANGE THIS?
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # CHANGE THIS?
				# I think this sed statement needs to be changed
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET_IN|${data_bucket_input}|g" -e "s|BUCKET_OUT|${data_bucket_output}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${sync_template} > ${sync_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${sync_folder}

'''
sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_sync.sh 


cat /home/rando149/shared/projects/ABCC_year2_dcm2bids_06142022/toconverttoBIDS_year2.txt | while read line; do
	echo ${line} > ${dicom2bids_subjects}/${line}.txt
	sed -e "s:SUBJECTID:${line}:g" -e "s:SUBJECTDIR:${dicom2bids_subjects}:g" ${run_folder}/template.dicom2bids > ${dicom2bids_folder}/run${k}

	k=$((k+1))
done

