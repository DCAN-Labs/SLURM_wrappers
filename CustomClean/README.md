# CustomClean s3 wrapper

This wrapper pulls down data from a s3 bucket, then runs CustomClean to discard any unneeded files, before syncing the remaining files back to the s3.

Specify the s3 bucket and the path to the processed data in the s3 bucket in make_run_files.sh. Also verify the paths to the data in template.custom_clean. Specify the resources needed for running in resources_custom_clean.sh

Read more about CustomClean [here.](https://github.com/DCAN-Labs/CustomClean#readme)