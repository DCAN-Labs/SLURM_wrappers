# S3 External Sync/Transfer

This wrapper takes something from one S3 with one config file and transfers it to an S3 with a different config file. This syncs each subject-session one at a time to maximize efficiency with the `s3cmd` command. The more files you are syncing at once, the more there is for the command to index before starting to move files.

## Requirements

- a separate [.s3cfg](https://dcan-labs-informational-guide.readthedocs.io/en/latest/s3/#setting-up-a-s3cfg) for both systems you are syncing to/from
- a bucket that you have access to in both locations

