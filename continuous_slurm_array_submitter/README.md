# Continuous Slurm Arrary Submitter
This script should be utilized when you have more than 2000 jobs to submit (MSI's maximum queue size per user) or there's a thershold of simultaneous actions you are trying to avoid (example: 5000 s3 syncs at once). It submits your run files (produced by another wrapper) in specified chunks at given time intervals if there is room in your queue to try to submit.

```
usage: continuous_slurm_submitter.py [-h] [--partition PARTITION [PARTITION ...]] --job-name JOB_NAME --log-dir
                                     LOG_DIR --run_folder RUN_FOLDER [RUN_FOLDER ...] --n_cpus N_CPUS --time_limit
                                     TIME_LIMIT --tmp_storage TMP_STORAGE [--total_memory TOTAL_MEMORY]
                                     [--array-size ARRAY_SIZE] [--submission-interval SUBMISSION_INTERVAL]
                                     --account_name ACCOUNT_NAME [ACCOUNT_NAME ...] [--high-priority]
                                     [--emailed_user EMAILED_USER]

continuous MSI SLURM submitter script.

optional arguments:
  -h, --help            show this help message and exit
  --partition PARTITION [PARTITION ...]
                        The queue partition to use. Multiple queues can be specified by providing a space separated
                        list. For a selection of MSI partitions, see: https://www.msi.umn.edu/partitions
  --job-name JOB_NAME, --job_name JOB_NAME
                        A descriptive shorthand name to use for the job submission.
  --log-dir LOG_DIR, --log_dir LOG_DIR
                        The folder to output log files (STDOUT, STDERR) to.
  --run_folder RUN_FOLDER [RUN_FOLDER ...], --run-folder RUN_FOLDER [RUN_FOLDER ...]
                        The run folder/s to use, to build the job submission arrays. Can select multiple run
                        folders with a space separated list
  --n_cpus N_CPUS       Number of CPUs for submission
  --time_limit TIME_LIMIT, --time-limit TIME_LIMIT
                        SLURM job time limit. Expected format is HH:MM:SS (H=hours, M=minutes, S=seconds)
  --tmp_storage TMP_STORAGE, --tmp-storage TMP_STORAGE
                        Needed temporary storage for the length of a SLURM job. Expected format is in gigabytes
                        (i.e. 2 = 2gb)
  --total_memory TOTAL_MEMORY, --total-memory TOTAL_MEMORY
                        The total amount of memory/RAM to use for the submission. If using MSI, pay close attention
                        to the "Advised memory per core" column within: https://www.msi.umn.edu/partitions.
  --array-size ARRAY_SIZE, --array_size ARRAY_SIZE
                        Desired number of jobs to continuous be in the queue to be run. If using MSI, the max is
                        1000.
  --submission-interval SUBMISSION_INTERVAL, --submission_internval SUBMISSION_INTERVAL
                        How often should continuous batches be submitted, in minutes?
  --account_name ACCOUNT_NAME [ACCOUNT_NAME ...]
                        What account name to charge job too. If using MSI, you can discover group by typing `id
                        -nG`. Default is primary group (`id -ng`.). Can select multiple accounts with a space
                        separated list
  --high-priority, --high_priority
                        Run jobs with a higher priority. Note, you need special permission to run this
  --emailed_user EMAILED_USER
                        What user to e-mail when jobs begin, end, or fail. If not specified, default is the
                        @umn.edu for the submitting user.
```