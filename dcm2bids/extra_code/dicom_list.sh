
data_bucket="s3://mcdon-ohsu-adhd/unprocessed" 
for year in $(s3cmd ls "${data_bucket}/dicoms/"); do
    for month in $(s3cmd ls "${year}"); do
        for subfolder in $(s3cmd ls "${month}"); do
            subfolder_bn=$(basename "${subfolder}")
            # Check if the subfolder_bn contains "6943"
            if [[ "${subfolder_bn}" == *6943* ]]; then
                echo "${subfolder_bn}" >> dicombasenamelist.csv
            fi
        done
    done
done