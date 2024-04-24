 #!/bin/bash 

data_bucket="s3://mcdon-ohsu-adhd/unprocessed/niftis/"


for sub in $(s3cmd ls "${data_bucket}"); do
    for ses in $(s3cmd ls "${sub}"); do
        echo ${ses}
    done
done


# for sub in $(s3cmd ls "${data_bucket}"); do
#     for ses in $(s3cmd ls "${sub}"); do
#         for mod in $(s3cmd ls "${ses}"); do
#             if [ -z "$(s3cmd ls "${mod}")" ]; then
#                 echo ${sub}
#                 echo "Folder is empty"
#             fi
#         done
#     done
# done
