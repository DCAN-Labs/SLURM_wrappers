# DCAN Infant Wrapper (BCP subjects)
This wrapper runs pulls a single subject at a time from the s3 and runs DCAN-Infant pipeline on that subject. This script is specific for BCP subjects. It then pushes the outputs to an s3 bucket. 

S3 buckets are specified in the make_run_files.sh script. 

Read more about the DCAN infant pipeline [here.](https://github.com/DCAN-Labs/dcan-infant-pipeline#readme)