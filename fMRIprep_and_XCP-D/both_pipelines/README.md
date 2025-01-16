# slurm fmriprep / xcpd S3 wrapper
This wrapper grabs a single subject from the s3 at time to then run fmriprep and xcp-d on it. It then does some minor post-processing before pushing the outputs back to the s3. 

Description of each file/executable
- dataset_description.json	-> Template dataset_description.json file. This is required for fMRIPrep to run. Don't move or edit.'	
- license.txt	-> freesurfer license that fMRIPrep needs for processing. Don't move or edit			
- resources_fmriprep_full_run.sh -> resource request script when submitting fMRIPrep pipeline jobs to the SLURM queueing system
- make_run_files.sh	-> script does the following:
  1)  loops through BIDS directory, parsing out subject and session IDs, one by one
  2) each unique subject and session ID are used to modify the content of the template scripts
  3) Modified content of template scripts is saved as an executable named run<run number> in either the run_files.dMRI, run_files.fMRI, or run_files.sMRI folders
- submit_fmriprep_full_run.sh -> script used to submit job arrays to the cluster.			
- template.fmriprep_full_run -> template script to run fMRIPrep pipeline

Basic Usage/How To
- All scripts are highly tailorable depending on a given use case
- It is suggested to look at the template scripts first, there you can decide what arguments to include (or not) within each pipeline
- Next, look through "make_run_files.sh". Ensure that your BIDS directory is being traversed correctly.
- With run<run number> executables in place, jobs can be submitted to the cluster by executing "submit_fmriprep_full_run.sh". "submit_fmriprep_full_run.sh" accepts one argument, the job array.
