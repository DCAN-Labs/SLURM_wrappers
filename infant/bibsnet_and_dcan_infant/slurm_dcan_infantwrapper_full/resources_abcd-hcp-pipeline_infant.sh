#!/bin/bash -l
#SBATCH -J dcan-infant-pip-full
#SBATCH -c 128
#SBATCH --mem=480G
#SBATCH --tmp=240GB
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lundq163@umn.edu
#SBATCH -p ag2tb
#SBATCH -o output_logs/dcan_pip_end%A_%a.out
#SBATCH -e output_logs/dcan_pip_end%A_%a.err
#SBATCH -A faird

cd run_files.abcd-hcp-pipeline_infant

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
