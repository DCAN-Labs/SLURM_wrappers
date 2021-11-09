 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir=`cd ../../; pwd` # path to BIDS folder 
run_folder=`pwd`

dicom2bids_folder="${run_folder}/run_files.dicom2bids"
dicom2bids_template="template.dicom2bids"
dicom2bids_subjects="${run_folder}/sub_files.dicom2bids"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${dicom2bids_folder}" ]; then
	rm -rf "${dicom2bids_folder}"
	mkdir -p "${dicom2bids_folder}/logs"
else
	mkdir -p "${dicom2bids_folder}/logs"
fi

# counter to create run numbers
k=0

cat year_2_sub_list.txt | while read line; do
	sed -e "s:SUBJECTID:${line}:g" -e "s:DATADIR:${data_dir}:g" -e "s:RUNDIR:${run_folder}:g" -e "s:SUBJECTDIR:${dicom2bids_subjects}:g" ${run_folder}/template.dicom2bids > ${dicom2bids_folder}/run${k}
	echo ${line} > ${dicom2bids_subjects}/sub-${line}.txt

	k=$((k+1))
done

chmod +x -R ${dicom2bids_folder} 

sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/slurm_sMRI.sh 

