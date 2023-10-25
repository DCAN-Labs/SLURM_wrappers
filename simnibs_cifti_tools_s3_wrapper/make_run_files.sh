 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
run_folder=`pwd`

dicom2bids_folder="${run_folder}/run_files.dicom2bids"
dicom2bids_template="template.dicom2bids"
dicom2bids_subjects="${run_folder}/sub_files.dicom2bids"
data_local_dir="/home/miran045/shared/data/MSC_to_DCAN/"
data_tmp="/tmp/simnibs"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${dicom2bids_folder}" ]; then
	rm -rf "${dicom2bids_folder}"
	mkdir -p "${dicom2bids_folder}/logs"
else
	mkdir -p "${dicom2bids_folder}/logs"
fi

coordinates_dir="/home/miran045/shared/projects/Amal_neuromodulation/Experiments/All_coord_msc/sub-MSC01/exec1"

# counter to create run numbers
k=0

#looping through each subject and session using ls of tier 1 dir, then coordinate - to produce a run file per line per subject list_coord2 file

for i in `ls ${data_local_dir}`; do
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	coordinates="/home/miran045/shared/projects/Amal_neuromodperiments/All_coord_msc/sub-$subject/exec1/list_coord2" #loop through each line
	if [[ "sub" == "${sub_text}" ]]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		sed -e "s|SUBJECTID|${subj_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${abcd_hcp_pipeline_template} > ${abcd_hcp_pipeline_folder}/run${k}
		k=$((k+1))
	fi
done


chmod +x -R ${dicom2bids_folder} 

sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/slurm_dicom2bids.sh 

