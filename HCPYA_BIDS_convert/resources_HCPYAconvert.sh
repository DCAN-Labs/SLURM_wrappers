#!/bin/bash -l
#SBATCH --job-name=DEAPderiv
#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=10gb
#SBATCH --tmp=50gb
#SBATCH --output=output_logs/DEAPderiv_%A_%a.out
#SBATCH --error=output_logs/DEAPderiv_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH -A miran045
#SBATCH -p amdsmall,small

cd run_files.DEAPderiv

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}