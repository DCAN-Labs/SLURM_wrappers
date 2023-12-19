#!/usr/bin/env python

import os

# determine data directory, run folders, and run templates
data_dir="/tmp/bcp-cabinet-paper" # where to output data
data_bucket="s3://bcp-cabinet-paper/BIDS_input" # bucket that BIDS data will be pulled from and processed outputs will be pushed to
run_folder="/home/feczk001/shared/projects/cabinet_paper_results/intendedfors_on_s3_wrapper/"
# ses_id="" #comment out if using csv
intendedfors_folder="{run_folder}/run_files.intendedfors".format(run_folder=run_folder)
intendedfors_template="template.intendedfors_on_s3"

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if os.path.isdir(intendedfors_folder):
	os.system('rm -rf {intendedfors_folder}'.format(intendedfors_folder=intendedfors_folder))
	os.makedirs("{intendedfors_folder}/logs".format(intendedfors_folder=intendedfors_folder))
else:
	os.makedirs("{intendedfors_folder}/logs".format(intendedfors_folder=intendedfors_folder))
'''
# open subject lists within text files and make into python lists
with open(os.path.join(run_folder,'fully_converted_with_anat.txt')) as f:
    bids_subjs=f.readlines()
    bids_subjs=[bids_subj.strip('\n') for bids_subj in bids_subjs]
'''
'''
with open(os.path.join(run_folder,'abcdhcp_successes.txt')) as f:
    intendedfors_subjs=f.readlines()
    intendedfors_subjs=[intendedfors_subj.strip('\n') for intendedfors_subj in intendedfors_subjs]
'''

#if you have a two column csv

with open(os.path.join(run_folder, 'intendedfor_error_subs.csv')) as f:
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
      os.system('sed -e "s|SUBJECTID|{subj_id}|g" -e "s|SESID|{ses_id}|g" -e "s|DATADIR|{data_dir}|g" -e "s|BUCKET|{data_bucket}|g" -e "s|RUNDIR|{run_folder}|g" {run_folder}/{intendedfors_template} > {intendedfors_folder}/run{k}'.format(k=count,intendedfors_folder=intendedfors_folder,run_folder=run_folder,subj_id=subj_id,data_dir=data_dir,intendedfors_template=intendedfors_template,data_bucket=data_bucket,ses_id=ses_id))
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
os.system('chmod 775 -R {intendedfors_folder}'.format(intendedfors_folder=intendedfors_folder))
 

