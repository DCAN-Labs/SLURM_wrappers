# slurm xcpd S3 wrapper
This wrapper grabs a single subject's preprocessed data from the s3 at time to then run xcp-d on it. It then does some minor post-processing before pushing the outputs back to the s3. 

Description of each file/executable
- resources_xcpd.sh -> resource request script when submitting XCP-D pipeline jobs to the SLURM queueing system
- make_run_files.sh	-> script does the following:
  1) loops through preproc directory, parsing out subject and session IDs, one by one
  2) each unique subject and session ID are used to modify the content of the template scripts
  3) Modified content of template scripts is saved as an executable named run<run number> in the run_files.xcpd
- submit_xcpd_run.sh -> script used to submit job arrays to the cluster.			
- template.xcpd_run -> template script to run XCP-D pipeline

Basic Usage/How To
- All scripts are highly tailorable depending on a given use case
- It is suggested to look at the template scripts first, there you can decide what arguments to include (or not) within each pipeline
- Next, look through "make_run_files.sh". Ensure that your input directory is being traversed correctly.
- With run<run number> executables in place, jobs can be submitted to the cluster by executing "submit_xcpd_run.sh". "submit_xcpd_run.sh" accepts one argument, the job array.
