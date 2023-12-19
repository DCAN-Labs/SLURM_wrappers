# HCPYA BIDS Conversion Wrapper
This script pulls down one s3 subject at a time and then runs a BIDS conversion script. This is for HCP data to get converted to BIDS. It is then synced back to the s3. 

Specify the s3 bucket and the path to the data within the bucket in `make_run_files.sh`. Specify your email and resources in `resources_HCPYAconvert.sh`.
