#!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/home/feczk001/shared/projects/Jacob_test/input" #path to BIDS folder, hardcoded in for testing purposes!!!
run_folder="/home/faird/shared/code/internal/utilities/cabinet_wrappers/slurm_tier1_SE_scripts"

cabinet_folder="${run_folder}/run_files.cabinet" 
cabinet_template="template.cabinet"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders exist delete them and recreate
if [ -d "${cabinet_folder}" ]; then
	rm -rf "${cabinet_folder}"
	mkdir -p "${cabinet_folder}/logs"
else
	mkdir -p "${cabinet_folder}/logs"
fi

# counter to create run numbers
k=0

for i in `cd ${data_dir}; ls -d sub*`; do
	subj_id=`echo $i | awk  -F"-" '{print $2}'`
	sed -e "s:SUBJECTID:${subj_id}:g" -e "s:DATADIR:${data_dir}:g" -e "s:RUNDIR:${run_folder}:g" ${run_folder}/template.cabinet > ${cabinet_folder}/run${k}
	k=$((k+1))
done

chmod +x -R ${cabinet_folder} 

sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/resources_cabinet.sh 

