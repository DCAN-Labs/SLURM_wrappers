#!/bin/bash -l
#SBATCH --job-name=abcd2bids
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=10gb
#SBATCH --tmp=40gb
#SBATCH --output=output_logs/dicom2bids_%A_%a.out
#SBATCH --error=output_logs/dicom2bids_%A_%a.err
#SBATCH -A miran045
#SBATCH -p amdsmall,small

cd run_files.dicom2bids

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
