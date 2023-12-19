#!/usr/bin/env python

import os

# determine data directory, run folders, and run templates
data_dir="/tmp/PROJECT_NAME" # where to output data
data_bucket="s3://BUCKET_NAME" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder="ENTER/RUN/FOLDER"
#ses_id="2YearFollowUpYArm1" #comment out if using csv
abcd_hcp_pipeline_folder="{run_folder}/run_files.abcd-hcp-pipeline_full".format(run_folder=run_folder)
abcd_hcp_pipeline_template="template.abcd-hcp-pipeline_customclean"

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if os.path.isdir(abcd_hcp_pipeline_folder):
	os.system('rm -rf {abcd_hcp_pipeline_folder}'.format(abcd_hcp_pipeline_folder=abcd_hcp_pipeline_folder))
	os.makedirs("{abcd_hcp_pipeline_folder}/logs".format(abcd_hcp_pipeline_folder=abcd_hcp_pipeline_folder))
else:
	os.makedirs("{abcd_hcp_pipeline_folder}/logs".format(abcd_hcp_pipeline_folder=abcd_hcp_pipeline_folder))
'''
# open subject lists within text files and make into python lists
with open(os.path.join(run_folder,'fully_converted_with_anat.txt')) as f:
    bids_subjs=f.readlines()
    bids_subjs=[bids_subj.strip('\n') for bids_subj in bids_subjs]
'''
'''
with open(os.path.join(run_folder,'abcdhcp_successes.txt')) as f:
    abcd_hcp_pipeline_subjs=f.readlines()
    abcd_hcp_pipeline_subjs=[abcd_hcp_pipeline_subj.strip('\n') for abcd_hcp_pipeline_subj in abcd_hcp_pipeline_subjs]
'''

#if you have a two column csv

with open(os.path.join(run_folder, 'subject_list.csv')) as f:
    lines=f.readlines()
    bids_subjs = list()
    bids_ses = list()
    for line in lines:
      subj,ses=line.split(",")
      bids_subjs.append(subj)
      bids_ses.append(ses.strip('\n'))
      
count=0
for bids_subj in bids_subjs:
      subj_id=bids_subj # .strip('sub-')
      ses_id=bids_ses[count] # .strip('ses-')
      os.system('sed -e "s|SUBJECTID|{subj_id}|g" -e "s|SESID|{ses_id}|g" -e "s|DATADIR|{data_dir}|g" -e "s|SESID|{ses_id}|g" -e "s|BUCKET|{data_bucket}|g" -e "s|RUNDIR|{run_folder}|g" {run_folder}/{abcd_hcp_pipeline_template} > {abcd_hcp_pipeline_folder}/run{k}'.format(k=count,abcd_hcp_pipeline_folder=abcd_hcp_pipeline_folder,run_folder=run_folder,subj_id=subj_id,data_dir=data_dir,abcd_hcp_pipeline_template=abcd_hcp_pipeline_template,data_bucket=data_bucket,ses_id=ses_id))
      count+=1      
'''
count=0
for bids_subj in bids_subjs:
    if bids_subj not in abcd_hcp_pipeline_subjs:
        subj_id=bids_subj.strip('sub-')
        os.system('sed -e "s|SUBJECTID|{subj_id}|g" -e "s|DATADIR|{data_dir}|g" -e "s|SESID|{ses_id}|g" -e "s|BUCKET|{data_bucket}|g" -e "s|RUNDIR|{run_folder}|g" {run_folder}/{abcd_hcp_pipeline_template} > {abcd_hcp_pipeline_folder}/run{k}'.format(k=count,abcd_hcp_pipeline_folder=abcd_hcp_pipeline_folder,run_folder=run_folder,subj_id=subj_id,data_dir=data_dir,abcd_hcp_pipeline_template=abcd_hcp_pipeline_template,data_bucket=data_bucket,ses_id=ses_id))
        count+=1
'''
# change permissions of generated run files
os.system('chmod 775 -R {abcd_hcp_pipeline_folder}'.format(abcd_hcp_pipeline_folder=abcd_hcp_pipeline_folder))
 
