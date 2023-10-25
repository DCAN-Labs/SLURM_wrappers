 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_dir="/tmp/Rtemp/" # where to output data
data_bucket="s3://Rtempbucket" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder=`pwd`

Rtemp_folder="${run_folder}/run_files.Rtemp"
Rtemp_template="template.Rtemp"

group=`faird`

# if processing run folders exist delete them and recreate
if [ -d "${Rtemp_folder}" ]; then
	rm -rf "${Rtemp_folder}"
	mkdir -p "${Rtemp_folder}/logs"
else
	mkdir -p "${Rtemp_folder}/logs"
fi

# counter to create run numbers
k=0

for i in `s3cmd ls ${data_bucket}/Ftemps/ | awk '{print $4}'`; do
        tempf=`echo $i | awk -F/ '{print $5}'`
				sed -e "s|DATADIR|${data_dir}|g" -e "s|BUCKET|${i}|g" -e "s|RUNDIR|${run_folder}|g" -e "s|TEMPF|${tempf}|g"  ${run_folder}/${Rtemp_template} > ${Rtemp_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${Rtemp_folder}

sed -e "s|GROUP|${group}|g"  -i ${run_folder}/resources_Rtemp.sh 

