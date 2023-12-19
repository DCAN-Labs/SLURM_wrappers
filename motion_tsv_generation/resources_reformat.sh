#!/bin/bash -l
#SBATCH --job-name=reformat
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=10gb
#SBATCH --tmp=40gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<YOUR-EMAIL>@email.com
#SBATCH --output=output_logs/reformat_%A_%a.out
#SBATCH --error=output_logs/reformat_%A_%a.err
#SBATCH -p amdsmall,small

cd run_files

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
