#!/bin/bash

# Example S3 path
s3_subject_folder="s3://mcdon-ohsu-adhd/unprocessed/dicoms/2011/04/6943_2003_2_Stevens_Carpenter_"

# Extract the subject ID by capturing the text between the first underscore and '_Stevens'
subject_id=$(echo "$s3_subject_folder" | grep -oP '.*?_\K[0-9]+_[0-9]+(?=_Stevens)')

# Extract the session ID by capturing the year and month from the folder path
session_id=$(echo "$s3_subject_folder" | grep -oP 'dicoms/\K[0-9]{4}/[0-9]{2}' | sed 's/\(....\)\/\(..\)/\2\1/')


echo "S3 Subject Folder: $s3_subject_folder"
echo "Subject ID: $subject_id"
echo "Session ID: $session_id"
