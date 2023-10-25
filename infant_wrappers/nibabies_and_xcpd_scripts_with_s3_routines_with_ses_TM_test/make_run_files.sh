#!/bin/bash

set +x 

# Initialize variables with default values
s3_bids_path="" # BIDS directory on S3 bucket where BIDS data will be pulled from (include "s3://")
s3_precomputed_path="" # BIDS directory on S3 bucket where precomputed derivatives will be pulled from (include "s3://")
s3_upload_path="" # where to upload output to on S3
nibabies_dir="" # parent directory to create for nibabies input, derivatives, and work
precomputed_dir="" # parent directory to create for precomputed derivatives
xcpd_dir="" # parent directory to create for xcp_d derivatives and work
band_stop_min="" # optional: sets xcp_d respiratory filter min/max freq; if one of min/max is specified then both must be specified
band_stop_max="" 
skip_nibabies=false # skip nibabies 
skip_xcpd=false # skip xcp_d
surface_recon_method # nibabies surface recon method (one of "mcribs", "infantfs" (default), "freesurfer")
nibabies_clean_workdir=false # run nibabies with --clean-workdir
xcpd_clean_workdir=false # run xcp_d with --clean-workdir
low_resources=false # request reduced resources (default: 120c/960G/48:00:00; low: 24c/240G/48:00:00)
skip_runfiles_backup=false # if not true, back up existing files in run files dir into a subdir with the current date/time
run_folder=`pwd`

# Define usage function
function usage {
  echo "Usage: $0 --s3-bids-path S3_URL --s3-upload-path S3_URL --nibabies-dir NIBABIES_DIR --xcpd-dir XCPD_DIR [--s3-precomputed-path S3_URL] [--precomputed-dir DIR] [--surface-recon-method {mcribs,infantfs,freesurfer} ][--band-stop-min FLOAT] [--band-stop-max FLOAT] [--skip-nibabies] [--skip-xcpd] [--nibabies-clean-workdir] [--xcpd-clean-workdir] [--low-resources] [--skip-runfiles-backup]"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --s3-bids-path)
      s3_bids_path="$2"
      shift
      shift
      ;;
    --s3-precomputed-path)
      s3_precomputed_path="$2"
      shift
      shift
      ;;
    --s3-upload-path)
      s3_upload_path="$2"
      shift
      shift
      ;;
    --nibabies-dir)
      nibabies_dir="$2"
      shift
      shift
      ;;
    --precomputed-dir)
      precomputed_dir="$2"
      shift
      shift
      ;;
    --xcpd-dir)
      xcpd_dir="$2"
      shift
      shift
      ;;
    --surface-recon-method)
      surface_recon_method="$2"
      shift
      shift
      ;;
    --band-stop-min)
      band_stop_min="$2"
      shift
      shift
      ;;
    --band-stop-max)
      band_stop_max="$2"
      shift
      shift
      ;;
    --skip-nibabies)
      skip_nibabies=true
      shift
      ;;
    --skip-xcpd)
      skip_xcpd=true
      shift
      ;;
    --nibabies-clean-workdir)
      nibabies_clean_workdir=true
      shift
      ;;
    --xcpd-clean-workdir)
      xcpd_clean_workdir=true
      shift
      ;;
    --low-resources)
      low_resources=true
      shift
      ;;
    --skip-runfiles-backup)
      skip_runfiles_backup=true
      shift
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# Check that required arguments are provided
if [[ -z "$s3_bids_path || -z "$s3_upload_path || -z "$nibabies_dir" || -z "$xcpd_dir" ]]; then
  usage
  exit 1
fi

# Check that --band-stop-min and --band-stop-max are provided together
if [[ ! -z "$band_stop_min" && -z "$band_stop_max" ]]; then
  usage
  exit 1
elif [[ -z "$band_stop_min" && ! -z "$band_stop_max" ]]; then
  usage
  exit 1
fi


nibabies_folder="${run_folder}/run_files.nibabies_full"
nibabies_template="template.nibabies_full_run"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if specified, back up existing runfiles
if [[ "$skip_runfiles_backup" = false ]] ; then
    backup_datetime=$(date +%F_%_H_%M_%S)
    mkdir -p ${nibabies_folder}/backup/${backup_datetime}
    cp ${nibabies_folder}/run* ${nibabies_folder}/backup/${backup_datetime}
fi

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${nibabies_folder}" ]; then
	rm -rf "${nibabies_folder}"
	mkdir -p "${nibabies_folder}/logs"
else
	mkdir -p "${nibabies_folder}/logs"
fi


# counter to create run numbers
k=0

for i in `s3cmd ls "${s3_bids_path}"/ | awk '{print $2}'`; do
	# does said folder include subject folder?
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls "${s3_bids_path}"/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` 
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|NIBABIESDIR|${nibabies_dir}|g" -e "s|PRECOMPUTEDDIR|${precomputed_dir}|g" -e "s|XCPDDIR|${xcpd_dir}|g" -e "s|S3BIDSPATH|${s3_bids_path}|g" -e "s|S3PRECOMPUTEDPATH|${s3_precomputed_path}|g" -e "s|S3UPLOADPATH|${s3_upload_path}|g" -e "s|RUNDIR|${run_folder}|g" -e "s|BSMIN|${band_stop_min}|g" -e "s|BSMAX|${band_stop_max}|g" -e "s|SKIPNIBABIES|${skip_nibabies}|g" -e "s|RECONMETHOD|${surface_recon_method}|g" -e "s|SKIPXCPD|${skip_xcpd}|g" -e "s|NIBABIESCLEAN|${nibabies_clean_workdir}|g" -e "s|XCPDCLEAN|${xcpd_clean_workdir}|g" ${run_folder}/${nibabies_template} > ${nibabies_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${nibabies_folder}

if [[ "$low_resources" = true ]] ; then
    cp -f resources_nibabies_full_run_low.sh resources_nibabies_full_run_copy.sh
else
    cp -f resources_nibabies_full_run.sh resources_nibabies_full_run_copy.sh
fi
sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_nibabies_full_run_copy.sh 

