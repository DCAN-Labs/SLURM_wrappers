 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp" # where to output data
data_bucket_in="s3://abcc-year2-derivatives-part2/derivatives/abcd-hcp-pipeline-v0.1.3" # bucket that BIDS data will be pulled from
data_bucket_out="s3://umn-transfer/derivatives/abcd-hcp-pipeline-v0.1.3" # bucket that processed outputs will be pushed to
run_folder="/home/rando149/shared/projects/ABCC_year2_v013_DEAPtransfer/slurm_deap_sync"

s3tos3_filemap_folder="${run_folder}/run_files.s3tos3_filemap"
s3tos3_filemap_template="template.s3tos3_filemapper"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${s3tos3_filemap_folder}" ]; then
	rm -rf "${s3tos3_filemap_folder}"
	mkdir -p "${s3tos3_filemap_folder}/logs"
else
	mkdir -p "${s3tos3_filemap_folder}/logs"
fi

ses_id='2YearFollowUpYArm1'

# Option 1: When giving the wrapper subject list
k=0
for i in $( cat new_year2_subject_list.txt ); do
	sed -e "s|SUBJECTID|${i}|g" -e "s|SESID|ses-${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET_IN|${data_bucket_in}|g" -e "s|BUCKET_OUT|${data_bucket_out}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/template.s3tos3_filemapper > ${s3tos3_filemap_folder}/run${k}
	k=$((k+1))
done


chmod 775 -R ${s3tos3_filemap_folder}

sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_s3tos3_filemapper.sh 

