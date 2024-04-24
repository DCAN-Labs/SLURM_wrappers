 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_bucket="s3://BUCKET" 
work_dir="/tmp"
run_folder=`pwd`

dcm2bids_folder="${run_folder}/run_files.dcm2bids"
dcm2bids_template="template.dcm2bids"
dcm2bids_subjects="${run_folder}/sub_files.dcm2bids"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${dcm2bids_folder}" ]; then
	rm -rf "${dcm2bids_folder}"
	mkdir -p "${dcm2bids_folder}"
else
	mkdir -p "${dcm2bids_folder}"
fi

# counter to create run numbers
k=0

# ENSURE S3 STRUCTURE IS CORRECT
for year in $(s3cmd ls "${data_bucket}/dicoms/"); do
    for month in $(s3cmd ls "${year}"); do
        for subfolder in $(s3cmd ls "${month}"); do
            subfolder_bn=$(basename "${subfolder}")
            # Check if the subfolder_bn contains "6943"
            if [[ "${subfolder_bn}" == *6943* ]]; then
                sed -e "s|SUBFOLDER|${subfolder}|g" -e "s|WORKDIR|${work_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${dcm2bids_template} > ${dcm2bids_folder}/run${k}
				k=$((k+1))
            fi
        done
    done
done

chmod +x -R ${dcm2bids_folder} 
sed -e "s:GROUP:${group}:g" -e "s:EMAIL:${email}:g" -i ${run_folder}/resources_dcm2bids.sh




