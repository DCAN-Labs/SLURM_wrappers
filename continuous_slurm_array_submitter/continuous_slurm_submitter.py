#!/usr/bin/env python
#
# WED JUL 14 2021 @ 7am
# Tim Hendrickson reimplemented this script within python for better error handling 
#
# SUN NOV 25 @ 5pm
#   Eric Earl modified batch_subject_submitter.sh to generalize to other batch needs
# 
# WED NOV 28 @ 10am
#   Eric Earl further modified batch_subject_conductor.sh to make this an easy fill-in-the-blank template
# 

# WED NOV 26 2019 @ 3pm
#   Robert Hermosillo modified this script to allow for submission of subjects with multiple visit dates.  Now the subject list should be formatted "sub-XXX_ses-YYY"

import argparse
import os
import subprocess
import time
from subprocess import Popen, PIPE
from glob import glob
import pdb 

# capture output from linux CLIs
def run(command):
    process = Popen(command, stdout=PIPE, stderr=subprocess.STDOUT,shell=True)
    output = process.stdout.readline()
    output = output.decode('utf-8').strip('\n')
    return output

parser = argparse.ArgumentParser(description='continuous MSI SLURM submitter script.')
parser.add_argument('--partition', default=['small','amdsmall'], help='The queue partition to use. Multiple queues can be specified by providing a space separated list.'
                ' For a selection of MSI partitions, see: https://www.msi.umn.edu/partitions',
                nargs="+")
parser.add_argument('--job-name','--job_name',required=True, help='A descriptive shorthand name to use for the job submission.')
parser.add_argument('--log-dir','--log_dir',required=True, help='The folder to output log files (STDOUT, STDERR) to.')
parser.add_argument('--run_folder', '--run-folder',required=True, help='The run folder/s to use, to build the job submission arrays. Can select multiple run folders with a space separated list ',
                   nargs="+")
parser.add_argument('--n_cpus',required=True,help='Number of CPUs for submission',type=int)
parser.add_argument('--time_limit','--time-limit', 
                    help='SLURM job time limit. Expected format is HH:MM:SS (H=hours, M=minutes, S=seconds)',
                   required=True)
parser.add_argument('--tmp_storage','--tmp-storage', 
                    help='Needed temporary storage for the length of a SLURM job. Expected format is in gigabytes (i.e. 2 = 2gb)',
                   required=True, type=int)
parser.add_argument('--total_memory', '--total-memory', help='The total amount of memory/RAM to use for the submission. '
                   'If using MSI, pay close attention to the "Advised memory per core" column within: https://www.msi.umn.edu/partitions.',
                   default=2, type=int)
parser.add_argument('--array-size', '--array_size', help='Desired number of jobs to continuous be in the queue to be run. If using MSI, the max is 1000.',
                    default=1000, type=int)
parser.add_argument('--submission-interval','--submission_internval', help='How often should continuous batches be submitted, in minutes?',default=10,type=int)
parser.add_argument('--account_name',nargs='+',help='What account name to charge job too. If using MSI, you can discover group by typing `id -nG`. Default is primary group (`id -ng`.). Can select multiple accounts with a space separated list',required=True)
parser.add_argument('--high-priority','--high_priority',help='Run jobs with a higher priority. Note, you need special permission to run this',action='store_true')

# Parse and gather arguments
args = parser.parse_args()
print(args)
script_path=os.path.dirname(__file__)
# validate integrity of inputted arguments
user_name = run(command='whoami')
#if not args.account_name:
#    account_name = run(command='id -ng')
#else:
#    account_name = args.account_name
#    all_account_names = run(command='id -nG')
#    assert account_name in all_account_names, 'You are not a member of the account you specified: ' + account_name + '. Exiting.'
if not os.path.isdir(args.log_dir):
    os.system("mkdir -p {log_dir}".format(log_dir=args.log_dir)) # make folder based on provided account
    os.system("chmod 777 {log_dir}".format(log_dir=args.log_dir)) # make folder based on provided account
job_name = args.job_name
for run_folder in args.run_folder:
  assert os.path.exists(run_folder),'run folder ' + run_folder + ' does not exist. Exiting.'
if len(args.partition) > 1:
  args.partition = ','.join([str(elem) for elem in args.partition])
else:
  args.partition = args.partition[0]
if len(args.account_name) > 1:
    args.account_name = ','.join([str(elem) for elem in args.account_name])
else:
    args.account_name = args.account_name[0]
if args.high_priority:
    priority_text = '-q highprio'
else:
    priority_text = ''
# at MSI verify if on mesabi or mangi
dns_name = run(command="dnsdomainname")
assert dns_name.split('.')[0]=='mesabi' or dns_name.split('.')[0]=='mangi', 'Must be on mesabi or mangi in order to submit jobs.' 

total_run_files_length = 0 
for run_folder in args.run_folder:
    run_files_length = len(glob(os.path.join(run_folder,'*run*')))
    total_run_files_length += run_files_length
while True:
    try:
        submitted_subject_lines = open('{log_dir}/submitted_subjects_job-{jobname}.txt'.format(log_dir=args.log_dir,jobname=job_name),'r').readlines()
    except:
        pass
    else:
        if len(submitted_subject_lines) == total_run_files_length:
            break
    # check for jobs in the queue with this job's short 8-character name and if the count is above the "queuing threshold"...
    jobs_in_queue = int(run(command='squeue -r -n ' + job_name + ' | wc -l'))
    while jobs_in_queue >= args.array_size:
        time.sleep(args.submission_interval*60) # wait before checking again in a while loop
    
    jobs_to_submit = args.array_size - jobs_in_queue
    fairshares=list()
    for account in args.account_name.split(','):
        fairshare=float(run(command="sshare --account="+account+" | grep " + user_name + " | awk '{print $NF}'"))
        fairshares.append(fairshare)
    jobs_to_submit_by_account=[round((fairshare/sum(fairshares)) * jobs_to_submit) for fairshare in fairshares]
    job_count = 0 # keep track of number of jobs
    # for each run folder in submitted run folders
    for run_folder in args.run_folder:
        # for each run file within each run folder
        run_files = glob(os.path.join(run_folder,'*run*'))
        run_files_length = len(run_files)
        run_file_list=[]
        for run_file_count, run_file in enumerate(run_files):
            run_file_num = os.path.basename(run_file).split('run')[1].strip('.sh')
            run_file_lines = open(run_file,'r').readlines()
            for line in run_file_lines: 
                if 'subject_id=' in line:
                    subject_id=line.split("=")[1].strip()
            assert subject_id,'could not find subject ID'
            try: 
                submitted_subject_lines = open('{log_dir}/submitted_subjects_job-{jobname}.txt'.format(log_dir=args.log_dir,jobname=job_name),'r').readlines()
            except:
                # open file to append, even if it does not exist  
                with open('{log_dir}/submitted_subjects_job-{jobname}.txt'.format(log_dir=args.log_dir,jobname=job_name),'a+') as f:
                    f.write(subject_id+'\n')
                run_file_list.append(run_file_num)
                job_count += 1
            else:
                # if file can be opened but cannot find subject, append to submission list
                found_subject = 0
                for line in submitted_subject_lines:
                    if subject_id in line:
                        found_subject = 1
                        break
                if found_subject == 0:
                    with open('{log_dir}/submitted_subjects_job-{jobname}.txt'.format(log_dir=args.log_dir,jobname=job_name),'a+') as f:
                        f.write(subject_id+'\n')
                    run_file_list.append(run_file_num)
                    job_count += 1
                    
            if job_count == jobs_to_submit or ((run_file_count + 1)==run_files_length) or ((run_file_count + 1)==total_run_files_length):
                start=0
                for idx,submission_size in enumerate(jobs_to_submit_by_account):
                    end=int(start+submission_size+1)
                    if not start+1==end:
                        account_name=args.account_name.split(',')[idx]
                        account_run_file_list=run_file_list[start:end]
                        account_run_file_list=','.join([str(elem) for elem in account_run_file_list])
                        parsed_account_run_file_list = run(command='bash '+ script_path+'/job_array_modifier.sh ' + account_run_file_list)
                        print("sbatch --array={array} -A {account_name} -J {job_name} -o {log_dir}/{job_name}_%A_%a.out -e {log_dir}/{job_name}_%A_%a.err -p {partition} --cpus-per-task {n_cpus} --mem={memory}gb {priority} --tmp={tmp_storage}gb -t {time} {path}/continuous_array_submitter.sh {run_folder}".format(
                            array=parsed_account_run_file_list,account_name=account_name,partition=args.partition,log_dir=args.log_dir,job_name=job_name,n_cpus=str(args.n_cpus),memory=str(args.total_memory),priority=priority_text,tmp_storage=args.tmp_storage, time=args.time_limit,run_folder=run_folder,path=script_path))
                        os.system("sbatch --array={array} -A {account_name} -J {job_name} -o {log_dir}/{job_name}_%A_%a.out -e {log_dir}/{job_name}_%A_%a.err -p {partition} --cpus-per-task {n_cpus} --mem={memory}gb {priority} --tmp={tmp_storage}gb -t {time} {path}/continuous_array_submitter.sh {run_folder}".format(
                            array=parsed_account_run_file_list,account_name=account_name,log_dir=args.log_dir,partition=args.partition,job_name=job_name,n_cpus=str(args.n_cpus),memory=str(args.total_memory),priority=priority_text,tmp_storage=args.tmp_storage,time=args.time_limit,run_folder=run_folder,path=script_path))
                        start=end
                    else:
                        start=end
                        continue
                time.sleep(args.submission_interval*60) # wait before checking again in a while loop
                break
            else:
                continue
        break
    
