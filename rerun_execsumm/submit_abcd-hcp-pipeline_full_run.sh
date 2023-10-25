#!/bin/bash -l

array=$1

if [ -z "$array" ]

then
      echo ""
      echo "No job array specified! Please enter jobs to run as argument:"
      echo ""
      echo "    EXAMPLE 1:  submit_ALL.sh 0-99"
      echo "    EXAMPLE 2:  submit_ALL.sh 1-3,6,9"
      echo ""

else
      echo ""
      echo "Submitting the following jobs for abcd-hcp-pipeline processing now: $array"
      echo ""

      abcd=$(sg rando149 -c "sbatch --parsable -a ${array} resources_abcd-hcp-pipeline_full_run.sh")

      echo "abcd-hcp-pipeline JOB ID: $abcd"

      echo ""
      echo "Output logs will appear in output_logs folder. Use 'squeue -al --me' to monitor jobs."
      echo ""
fi

