#!/bin/bash

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp/test" # where to output data
data_bucket="s3://abcd-new-year1" # bucket that derivative data will be pulled from and additional outputs will be pushed to
run_folder="/home/rando149/shared/projects/ABCC_year1_DEAPgeneration/slurm_DEAP-derivatives/"
#subject_list_file="/home/rando149/fayzu001/newfolder/slurm_DEAP-derivatives/subject.txt" # Path to the subject list file

DEAPderiv_folder="${run_folder}/run_files.DEAPderiv"
DEAPderiv_template="template.DEAPderiv"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${DEAPderiv_folder}" ]; then
	rm -rf "${DEAPderiv_folder}"
	mkdir -p "${DEAPderiv_folder}/logs"
else
	mkdir -p "${DEAPderiv_folder}/logs"
fi

#counter to create run numbers while looping through the bucket
k=0

for i in `s3cmd ls ${data_bucket}/derivatives/abcd-hcp-pipeline-v0.1.3/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket}/derivatives/abcd-hcp-pipeline-v0.1.3/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'` # CHANGE THIS?
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # CHANGE THIS?
				# I think this sed statement needs to be changed
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${DEAPderiv_template} > ${DEAPderiv_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

# counter to create run numbers when giving the wrapper path to the subjects list 
#k=0

# Read subject IDs from the subject list file
#while IFS= read -r subj_id; do
#	for j in `s3cmd ls ${data_bucket}/derivatives/abcd-hcp-pipeline-v0.1.3/sub-${subj_id}/ | awk '{print $2}'`; do
#		ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'` # CHANGE THIS?
#		if [ "ses" = "${ses_text}" ]; then
#			ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # CHANGE THIS?
#			# I think this sed statement needs to be changed
#			sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${DEAPderiv_template} > ${DEAPderiv_folder}/run${k}
#			k=$((k+1))
#		fi
#	done
#done < "$subject_list_file"

chmod 775 -R ${DEAPderiv_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/slurm_DEAPderiv.sh 
