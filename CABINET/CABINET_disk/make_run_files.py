#!/usr/bin/env python

import os

# determine data directory, run folders, and run templates
data_dir="/tmp" # where to output data
BIDS_folder="/home/elisonj/shared/BCP/UNC/UNC_BIDS" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder="/home/faird/shared/projects/eLABE_probabilistic_baby_atlas_processing/CABINET_wrapper_tier1_BCP"
# ses_id="" #comment out if using csv

json_folder="${run_folder}/json_files.cabinet_full".format(run_folder=run_folder)
json_template="bibsnet-nibabies-xcpd-template.json"
submit_folder="${run_folder}/run_files.cabinet_full".format(run_folder=run_folder)
submit_template="template.cabinet_full_run"

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if os.path.isdir(json_folder):
	os.system('rm -rf {json_folder}'.format(json_folder=json_folder))
	os.makedirs("{json_folder}/logs".format(json_folder=json_folder))
else:
	os.makedirs("{json_folder}/logs".format(json_folder=json_folder))
'''
# open subject lists within text files and make into python lists
with open(os.path.join(run_folder,'fully_converted_with_anat.txt')) as f:
    bids_subjs=f.readlines()
    bids_subjs=[bids_subj.strip('\n') for bids_subj in bids_subjs]
'''
'''
with open(os.path.join(run_folder,'abcdhcp_successes.txt')) as f:
    json_subjs=f.readlines()
    json_subjs=[json_subj.strip('\n') for json_subj in json_subjs]
'''
# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if os.path.isdir(submit_folder):
	os.system('rm -rf {submit_folder}'.format(submit_folder=submit_folder))
	os.makedirs("{submit_folder}/logs".format(submit_folder=submit_folder))
else:
	os.makedirs("{submit_folder}/logs".format(submit_folder=submit_folder))

#if you have a two column csv

with open(os.path.join(run_folder, 'subs.csv')) as f:
    lines=f.readlines()
    bids_subjs = list()
    bids_sess = list()
    for line in lines:
      subj,ses=line.split(",")
      bids_subjs.append(subj)
      bids_sess.append(ses.strip('\n'))
      
count=0
for bids_subj,bids_ses in zip(bids_subjs,bids_sess):
      subj_id=bids_subj.strip('sub-')
      ses_id=bids_ses.strip('ses-')
      os.system('sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|DATADIR|${data_dir}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${json_template} > ${json_folder}/${subj_id}.json'.format(json_folder=json_folder,run_folder=run_folder,subj_id=subj_id,data_dir=data_dir,json_template=json_template,ses_id=ses_id))
      os.system('sed -e "s|SUBJECTID|{subj_id}|g" -e "s|SESID|{ses_id}|g" -e "s|DATADIR|{data_dir}|g" -e "s|BIDSFOLDER|{BIDS_folder}|g" -e "s|RUNDIR|{run_folder}|g" {run_folder}/{submit_template} > {submit_folder}/run{k}'.format(k=count,submit_folder=submit_folder,run_folder=run_folder,subj_id=subj_id,data_dir=data_dir,submit_template=submit_template,BIDS_folder=BIDS_folder,ses_id=ses_id))
      count+=1      
'''
count=0
for bids_subj in bids_subjs:
    if bids_subj not in intendedfors_subjs:
        subj_id=bids_subj.strip('sub-')
        os.system('sed -e "s|SUBJECTID|{subj_id}|g" -e "s|DATADIR|{data_dir}|g" -e "s|SESID|{ses_id}|g" -e "s|BUCKET|{data_bucket}|g" -e "s|RUNDIR|{run_folder}|g" {run_folder}/{intendedfors_template} > {intendedfors_folder}/run{k}'.format(k=count,intendedfors_folder=intendedfors_folder,run_folder=run_folder,subj_id=subj_id,data_dir=data_dir,intendedfors_template=intendedfors_template,data_bucket=data_bucket,ses_id=ses_id))
        count+=1
'''
# change permissions of generated run files
os.system('chmod 775 -R {submit_folder}'.format(submit_folder=submit_folder))
 

