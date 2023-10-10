#!/bin/bash -l
#SBATCH --job-name=DEAPderiv
#SBATCH --time=2:30:00
#SBATCH --mem-per-cpu=30gb
#SBATCH --tmp=40gb
#SBATCH --output=output_logs/DEAPderiv_%A_%a.out
#SBATCH --error=output_logs/DEAPderiv_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hough129@umn.edu
#SBATCH -A feczk001
#SBATCH -p ag2tb

cd run_files.DEAPderiv

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
