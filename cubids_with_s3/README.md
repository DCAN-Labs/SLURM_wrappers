# cuBIDS s3 wrapper

This script pulls down subject data from the s3 and runs cuBIDS to validate it is in proper BIDS format. It creates an output csv (example provided is ADHD_ASD_validate.csv) with the errors from cuBIDS. Specifiy s3 and output location inmake_run_files.sh.