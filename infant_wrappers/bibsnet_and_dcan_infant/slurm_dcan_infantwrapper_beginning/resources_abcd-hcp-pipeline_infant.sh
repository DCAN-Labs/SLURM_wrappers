#!/bin/bash -l
#SBATCH -J infant_pip_beginning
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --tmp=60gb
#SBATCH --mem=480gb
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lundq163@umn.edu
#SBATCH -p ag2tb
#SBATCH -o output_logs/dcan_pip_%A_%a.out
#SBATCH -e output_logs/dcan_pip_%A_%a.err
#SBATCH -A faird

cd run_files.abcd-hcp-pipeline_infant

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
