# QSIprep S3 Slurm Wrapper
This wrapper pulls down a single subject from the s3, runs the first stage of [QSIprep](https://qsiprep.readthedocs.io/en/latest/), then syncs the outputs back to an s3 bucket. 

Set your email in the resources_QSIprep_run.sh script and set your s3 buckets in the make_run_files.sh script. This could be modified to run reconall very easily, as well.