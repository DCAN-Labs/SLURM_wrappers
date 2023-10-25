# slurm s3 abcd-hcp-pipeline wrapper with file mapper
This wrapper pulls down a single subject from the s3, runs the abcd-hcp-pipeline, runs filemapper, then syncs the outputs back to an s3 bucket. Set your email in the resources_abcd-hcp-pipeline_full_run.sh script and set your s3 buckets in the make_run_files.py script
