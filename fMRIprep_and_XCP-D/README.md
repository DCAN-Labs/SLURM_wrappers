# fMRIprep Wrappers

- **both_pipelines**: Run fMRIprep and XCP-D on input data stored on the s3. Push outputs to s3

- **XCP-D_only**: Run only XCP-D on input preprocessed data stored on the s3. Push outputs to s3.

Both wrappers are set up to loop through the input s3 bucket to search for subject and session IDs. 
If you want to loop through a subject list instead, check the make_run_files.sh file in the wrapper_template directory for the desired method. 
