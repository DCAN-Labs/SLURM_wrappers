# abcd-hcp-pipeline s3 wrapper with file mapper
This wrapper pulls down a single subject from the s3, runs the abcd-hcp-pipeline, runs filemapper, then syncs the outputs back to an s3 bucket. Set your email in the resources_abcd-hcp-pipeline_full_run.sh script and set your s3 buckets in the make_run_files.py script

Read more about the abcd-hcp-pipeline [here.](https://abcd-hcp-pipeline.readthedocs.io/en/latest/)

Read more about file-mapper [here.](https://github.com/DCAN-Labs/file-mapper#readme)