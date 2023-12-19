#!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="" #path to BIDS folder, hardcoded in for testing purposes!!!
run_folder=`pwd`

bibsnet_folder="${run_folder}/run_files.bibsnet" 
bibsnet_template="template.bibsnet"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders exist delete them and recreate
if [ -d "${bibsnet_folder}" ]; then
	rm -rf "${bibsnet_folder}"
	mkdir -p "${bibsnet_folder}/logs"
else
	mkdir -p "${bibsnet_folder}/logs"
fi

# counter to create run numbers
k=0

for i in `cd ${data_dir}; ls -d sub*`; do
	subj_id=`echo $i | awk  -F"-" '{print $2}'`
	sed -e "s:SUBJECTID:${subj_id}:g" -e "s:DATADIR:${data_dir}:g" -e "s:RUNDIR:${run_folder}:g" ${run_folder}/template.bibsnet > ${bibsnet_folder}/run${k}
	k=$((k+1))
done

chmod +x -R ${bibsnet_folder} 

sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/resources_bibsnet.sh 

