# DEAP Derivative Generation Wrapper
This wrapper pulls down a single subject-session's ABCD-BIDS derivatives from the s3, runs a few workbench commands to produce additional derivatives, then syncs the newly created derivatives backup to the s3. 

Set your email in the resources_DEAPderiv.sh script and set your s3 buckets in the make_run_files.sh script.
