# DEAP Sync Wrapper
This wrapper pulls down a single subject-session from the s3, runs filemapper to grab select derivatives (in this case DEAP, but you could use any file-mapper JSON), then syncs the file-mapped outputs to an s3 bucket on a different system. Set your email in the resources_s3tos3_filemapper.sh script and set your s3 buckets in the make_run_files.sh script. You may also want to change the file-mapper JSON.

Note: You will need access to both s3 systems you are sync to/from. You will also have to change the path to your s3 config within the sync commands if your naming doesn't match.

