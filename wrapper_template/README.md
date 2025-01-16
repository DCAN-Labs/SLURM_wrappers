# Wrapper Template

This wrapper provides a bare bones template for creating a new wrapper. Please visit [the Brain](https://cdnis-brain.readthedocs.io/wrappers/) to learn more about how s3 wrappers work. If you have any questions, reach out to rae (mccol199@umn.edu), who is more than willing to help get a new wrapper set up. 

In the template file, enter the code needed to run your process. Alter the variables needed for your process here and in the make_run_files.sh file, which is where they are set. If you are adding new variables, you'll need to edit the sed statements that happen in the for loop of the make_run_files.sh file. Adjust your resources to what you think you'll need. See the [Resource Optimization page of the Brain](https://cdnis-brain.readthedocs.io/optimizing/) for information on how to determine your resources. 

It is recommended to change the submit_run.sh file and the resource file to have the name of the process you are running (the current template just has the word "process" as the job name). To be consistent with the formatting of other wrappers, you can also add your process name to the end of the resources.sh, submit_run.sh, and template file, as well as the run_files. For example, if you are running a pipeline named T2star, this is what your directory would look like:

```
output_logs
run_files.T2star
make_run_files.sh
resources_T2star.sh
submit_T2star_run.sh
template.T2star
```

This renaming is not a requirement. If you choose to rename these files, you will also need to edit these names within the resources, make_run_files, and submit_run scripts. 