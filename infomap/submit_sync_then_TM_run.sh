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
      echo "Submitting the following jobs for Sync_then_TM processing now: $array"
      echo ""

      syncTM=$(sbatch --parsable -a $array resources_TM_run.sh)

      echo "syncTM JOB ID: $syncTM"

      echo ""
      echo "Use 'squeue -al --me' to monitor jobs."
      echo ""
fi

