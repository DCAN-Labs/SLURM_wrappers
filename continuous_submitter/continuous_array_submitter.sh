#!/bin/bash -l

cd $1

module load singularity

file=`ls *run${SLURM_ARRAY_TASK_ID}*`

bash ${file}
