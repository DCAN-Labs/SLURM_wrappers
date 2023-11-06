#!/usr/bin/env python

import os

# determine data directory, run folders, and run templates
data_dir="/tmp/year1_move_buckets" # where to output data
bucket_name="s3://abcd_reprocessing" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder=os.getcwd()
# ses_id="2YearFollowUpYArm1" #comment out if using csv
move_subjects_folder="{run_folder}/run_files.move_subjects".format(run_folder=run_folder)
move_subjects_template="template.move_subjects"

# if run folders exist delete them and recreate
if os.path.isdir(move_subjects_folder):
	os.system('rm -rf {move_subjects_folder}'.format(move_subjects_folder=move_subjects_folder))
	os.makedirs("{move_subjects_folder}/logs".format(move_subjects_folder=move_subjects_folder))
else:
	os.makedirs("{move_subjects_folder}/logs".format(move_subjects_folder=move_subjects_folder))
'''
# open subject lists within text files and make into python lists
with open(os.path.join(run_folder,'fully_converted_with_anat.txt')) as f:
    bids_subjs=f.readlines()
    bids_subjs=[bids_subj.strip('\n') for bids_subj in bids_subjs]
'''
'''
with open(os.path.join(run_folder,'abcdhcp_successes.txt')) as f:
    move_subjects_subjs=f.readlines()
    move_subjects_subjs=[move_subjects_subj.strip('\n') for move_subjects_subj in move_subjects_subjs]
'''

#if you have a two column csv

with open(os.path.join(run_folder, 'cert_ver_fail_ids.csv')) as f:
    lines=f.readlines()
    bids_subjs = list()
    bids_ses = list()
    for line in lines:
      subj,ses=line.split(",")
      bids_subjs.append(subj)
      bids_ses.append(ses.strip('\n'))
      
count=0
for bids_subj in bids_subjs:
      sub_id=bids_subj # .strip('sub-')
      ses_id=bids_ses[count]
      os.system('sed -e "s|SUBJECTID|{sub_id}|g" -e "s|SESSIONID|{ses_id}|g" -e "s|DATADIR|{data_dir}|g" -e "s|BUCKET|{bucket_name}|g" -e "s|RUNDIR|{run_folder}|g" {run_folder}/{move_subjects_template} > {move_subjects_folder}/run{k}'.format(k=count,move_subjects_folder=move_subjects_folder,run_folder=run_folder,sub_id=sub_id,ses_id=ses_id,data_dir=data_dir,move_subjects_template=move_subjects_template,bucket_name=bucket_name))
      count+=1
# change permissions of generated run files
os.system('chmod 775 -R {move_subjects_folder}'.format(move_subjects_folder=move_subjects_folder))
 

