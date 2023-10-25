#!/bin/bash -l

array=$1

if [ -z "$array" ]

then
      echo ""
      echo "No job array specified! Please enter jobs to run as argument:"
      echo ""
      echo "    EXAMPLE 1:  submit_Rtemp.sh 0-99"
      echo "    EXAMPLE 2:  submit_Rtemp.sh 1-3,6,9"
      echo ""

else
      echo ""
      echo "Submitting the following jobs for Rtemp now: $array"
      echo ""

      Rtemp=$(sbatch --parsable -a $array resources_Rtemp.sh)

      echo "Rtemp JOB ID: $Rtemp"

      echo ""
      echo "Output logs will appear in output_logs folder. Use 'squeue -al --me' to monitor jobs."
      echo ""
fi

