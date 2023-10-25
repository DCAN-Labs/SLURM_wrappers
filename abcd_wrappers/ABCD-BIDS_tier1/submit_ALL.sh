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
      echo "Submitting the following jobs for sMRI processing now: $array"
      echo ""

      sMRI=$(sbatch --parsable -a $array slurm_sMRI.sh)
      fMRI=$(sbatch --parsable --dependency=aftercorr:${sMRI} -a $array slurm_fMRI.sh)
      
      echo "sMRI JOB ID: $sMRI"
      echo "fMRI JOB ID: $fMRI"


      echo ""
      echo "If a job sucessfully completes sMRI processing, fMRI processing jobs will begin in parallel." 
      echo ""
      echo "Output logs will appear in output_logs folder. Use 'squeue -al --me' to monitor jobs."
      echo ""
fi

