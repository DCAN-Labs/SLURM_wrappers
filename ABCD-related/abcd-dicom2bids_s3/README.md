# abcd-dicom2bids wrapper

This wrapper creates a run file for each subject in a provided subject list. For each subject, it runs abcd-dicom2bids then pushes the output to the s3 bucket. This will also sync the EventRelatedInformation (ERI) data to a sourcedata subfolder in the same s3 bucket. 

In the template.dicom2bids you'll need to specify the s3 bucket, any working directories (output, work, and downloaded dirs), the year of the data you're trying to convert, and the package number of the ABCD package you've already created. Also make sure that you're using the most up to date fasttrack qc document. 

Give the path to the subject list in make_run_files.sh, and specify your resources to run in resources_dicom2bids.sh.

Read more information about abcd-dicom2bids [here](https://github.com/DCAN-Labs/abcd-dicom2bids#readme)
