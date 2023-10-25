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
      echo "Submitting the following jobs for nibabies processing now: $array"
      echo ""

      nibabies=$(sbatch --parsable -a $array resources_nibabies_full_run_lowest_resources.sh)

      echo "nibabies JOB ID: $nibabies"

      echo ""
      echo "Use 'squeue -al --me' to monitor jobs."
      echo ""
fi

