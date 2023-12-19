# cuBIDS s3 wrapper

This script pulls down subject data from the s3 and runs cuBIDS to validate it is in proper BIDS format. It creates an output csv (example provided is `ADHD_ASD_validate.csv`) with the errors from cuBIDS. Specifiy s3 and output location in `make_run_files.sh`.

To trim the outputs, we recommend using `query_cubids_errors` [here](https://github.com/DCAN-Labs/MSI-utilities/tree/main/query_cubids_errors).
