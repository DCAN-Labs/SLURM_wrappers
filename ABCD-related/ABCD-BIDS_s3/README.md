# abcd-hcp-pipeline s3 wrapper
This wrapper pulls down BIDS data from the s3 and runs the abcd-hcp-pipeline on one subject at a time. It then runs custom clean to clean up the files it created in the process. Finally, it syncs the outputs back to an s3 bucket. The variables you need to change are located in the resources_abcd-hcp-pipeline_full_run.sh (where you need to change your email) and make_run_files.sh (where you specify the s3 buckets)

Read more about the abcd-hcp-pipeline [here.](https://abcd-hcp-pipeline.readthedocs.io/en/latest/)

Read more about CustomClean [here.](https://github.com/DCAN-Labs/CustomClean#readme)