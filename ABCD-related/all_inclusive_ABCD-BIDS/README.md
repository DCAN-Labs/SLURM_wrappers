# All inclusive ABCD-BIDS wrapper

This wrapper runs the abcd-hcp-pipeline, then file-mapper, then generates DEAP derivatives. It pulls subjects from a s3 bucket then syncs the outputs back to the s3 bucket under /processed/abcd-hcp-pipeline-v0.1.3/.

You need to specify the s3 bucket in make_run_files.py as well as the subject list. 