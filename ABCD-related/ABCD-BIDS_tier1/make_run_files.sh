 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir=`cd ../../; pwd` # path to BIDS folder 
run_folder=`pwd`

sMRI_folder="${run_folder}/run_files.sMRI"
sMRI_template="template.sMRI"

fMRI_folder="${run_folder}/run_files.fMRI"
fMRI_template="template.fMRI"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${sMRI_folder}" ]; then
	rm -rf "${sMRI_folder}"
	mkdir -p "${sMRI_folder}/logs"
else
	mkdir -p "${sMRI_folder}/logs"
fi
if [ -d "${fMRI_folder}" ]; then
	rm -rf "${fMRI_folder}"
	mkdir -p "${fMRI_folder}/logs"
else
	mkdir -p "${fMRI_folder}/logs"
fi

# counter to create run numbers
k=0

for i in `cd ${data_dir}; ls -d sub*`; do
	subj_id=`echo $i | awk  -F"-" '{print $2}'`
	sed -e "s:SUBJECTID:${subj_id}:g" -e "s:DATADIR:${data_dir}:g" -e "s:RUNDIR:${run_folder}:g" ${run_folder}/template.sMRI > ${sMRI_folder}/run${k}
	sed -e "s:SUBJECTID:${subj_id}:g" -e "s:DATADIR:${data_dir}:g" -e "s:RUNDIR:${run_folder}:g" ${run_folder}/template.fMRI > ${fMRI_folder}/run${k}
	k=$((k+1))
done

chmod +x -R ${sMRI_folder} ${fMRI_folder}

sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/resources_sMRI.sh 
sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/resources_fMRI.sh 

